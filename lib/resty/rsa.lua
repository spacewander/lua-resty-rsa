-- Copyright (C) by Zhu Dejiang (doujiang24)


local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_cast = ffi.cast
local ffi_gc = ffi.gc
local ffi_copy = ffi.copy
local ffi_str = ffi.string
local C = ffi.C
local setmetatable = setmetatable


local _M = { _VERSION = '0.01' }

local mt = { __index = _M }


local PADDING = {
    RSA_PKCS1_PADDING = 1,  -- RSA_size - 11
    RSA_SSLV23_PADDING = 2, -- RSA_size - 11
    RSA_NO_PADDING = 3,     -- RSA_size
    RSA_PKCS1_OAEP_PADDING = 4, -- RSA_size - 42
}
_M.PADDING = PADDING


ffi.cdef[[
typedef struct bio_st BIO;
typedef struct bio_method_st BIO_METHOD;
BIO_METHOD *BIO_s_mem(void);
BIO * BIO_new(BIO_METHOD *type);
int	BIO_puts(BIO *bp,const char *buf);
void BIO_vfree(BIO *a);

typedef struct rsa_st RSA;
void RSA_free(RSA *rsa);
typedef int pem_password_cb(char *buf, int size, int rwflag, void *userdata);
RSA * PEM_read_bio_RSAPrivateKey(BIO *bp, RSA **rsa, pem_password_cb *cb,
								void *u);
RSA * PEM_read_bio_RSAPublicKey(BIO *bp, RSA **rsa, pem_password_cb *cb,
                                void *u);

unsigned long ERR_get_error(void);
const char * ERR_reason_error_string(unsigned long e);

typedef struct evp_pkey_st EVP_PKEY;
typedef struct engine_st ENGINE;
typedef struct evp_pkey_ctx_st EVP_PKEY_CTX;

EVP_PKEY *EVP_PKEY_new(void);
void EVP_PKEY_free(EVP_PKEY *key);
int EVP_PKEY_set1_RSA(EVP_PKEY *pkey,RSA *key);

EVP_PKEY_CTX *EVP_PKEY_CTX_new(EVP_PKEY *pkey, ENGINE *e);
void EVP_PKEY_CTX_free(EVP_PKEY_CTX *ctx);

int EVP_PKEY_CTX_ctrl(EVP_PKEY_CTX *ctx, int keytype, int optype,
                      int cmd, int p1, void *p2);

int EVP_PKEY_size(EVP_PKEY *pkey);

int EVP_PKEY_encrypt_init(EVP_PKEY_CTX *ctx);
int EVP_PKEY_encrypt(EVP_PKEY_CTX *ctx,
        unsigned char *out, size_t *outlen,
        const unsigned char *in, size_t inlen);

int EVP_PKEY_decrypt_init(EVP_PKEY_CTX *ctx);
int EVP_PKEY_decrypt(EVP_PKEY_CTX *ctx,
                     unsigned char *out, size_t *outlen,
                     const unsigned char *in, size_t inlen);

void OpenSSL_add_all_digests(void);
typedef struct env_md_st EVP_MD;
typedef struct env_md_ctx_st EVP_MD_CTX;
const EVP_MD *EVP_get_digestbyname(const char *name);
EVP_MD_CTX *EVP_MD_CTX_create(void);

int EVP_DigestInit(EVP_MD_CTX *ctx, const EVP_MD *type);
int EVP_DigestUpdate(EVP_MD_CTX *ctx, const unsigned char *in, int inl);
int EVP_SignFinal(EVP_MD_CTX *ctx,unsigned char *sig,unsigned int *s, EVP_PKEY *pkey);
int EVP_VerifyFinal(EVP_MD_CTX *ctx,unsigned char *sigbuf, unsigned int siglen,EVP_PKEY *pkey);
]]
--[[
# define EVP_PKEY_CTX_set_rsa_padding(ctx, pad) \
        EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, -1, EVP_PKEY_CTRL_RSA_PADDING, \
                                pad, NULL)
# define EVP_SignInit(a,b)               EVP_DigestInit(a,b)
# define EVP_SignUpdate(a,b,c)           EVP_DigestUpdate(a,b,c)
--]]


local EVP_PKEY_ALG_CTRL = 0x1000
local EVP_PKEY_CTRL_RSA_PADDING = EVP_PKEY_ALG_CTRL + 1
local NID_rsaEncryption = 6
local EVP_PKEY_RSA = NID_rsaEncryption

local function err()
    local code = C.ERR_get_error()

    local err = C.ERR_reason_error_string(code)

    return nil, ffi_str(err)
end


function _M.new(self, opts)
    local key, read_func, is_pub, md_ctx, md

    if opts.public_key then
        key = opts.public_key
        read_func = C.PEM_read_bio_RSAPublicKey
        is_pub = true

    elseif opts.private_key then
        key = opts.private_key
        read_func = C.PEM_read_bio_RSAPrivateKey

    else
        return nil, "not found public_key or private_key"
    end

    local bio_method = C.BIO_s_mem()
    local bio = C.BIO_new(bio_method)
    ffi_gc(bio, C.BIO_vfree)

    local len = C.BIO_puts(bio, key)
    if len < 0 then
        return err()
    end

    local pass
    if opts.password then
        local plen = #opts.password
        pass = ffi_new("unsigned char[?]", plen + 1)
        ffi_copy(pass, opts.password, plen)
    end

    local rsa = read_func(bio, nil, nil, pass)
    if ffi_cast("void *", rsa) == nil then
        return err()
    end
    ffi_gc(rsa, C.RSA_free)

    -- EVP_PKEY
    local pkey = C.EVP_PKEY_new()
    ffi_gc(pkey, C.EVP_PKEY_free)
    if C.EVP_PKEY_set1_RSA(pkey, rsa) == 0 then
        return err()
    end

    --EVP_PKEY_CTX
    local ctx = C.EVP_PKEY_CTX_new(pkey, nil)
    if ffi_cast("void *", ctx) == nil then
        return err()
    end
    ffi_gc(ctx, C.EVP_PKEY_CTX_free)

    -- md_ctx init for sign or verify; if signature algorithm is seted
    if opts.algorithm then
        C.OpenSSL_add_all_digests()

        md = C.EVP_get_digestbyname(opts.algorithm)
        if ffi_cast("void *", md) == nil then
            return nil, "Unknown message digest"
        end

        md_ctx = C.EVP_MD_CTX_create()
    end

    -- ctx init for encrypt or decrypt
    -- default for encrypt/decrypt if nothing is set
    if opts.padding or not opts.digest then
        local init_func = is_pub and C.EVP_PKEY_encrypt_init
                            or C.EVP_PKEY_decrypt_init
        if init_func(ctx) <= 0 then
            return err()
        end

        if C.EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, -1, EVP_PKEY_CTRL_RSA_PADDING,
                opts.padding or PADDING.RSA_PKCS1_PADDING, nil) <= 0 then
            return err()
        end
    end

    local size = C.EVP_PKEY_size(pkey)
    return setmetatable({
            pkey = pkey,
            size = size,
            buf = ffi_new("unsigned char[?]", size),
            _encrypt_ctx = is_pub and ctx or nil,
            _decrypt_ctx = not is_pub and ctx or nil,
            _sign_ctx = not is_pub and md_ctx or nil,
            _verify_ctx = is_pub and md_ctx or nil,
            md = md,
        }, mt)
end


function _M.decrypt(self, str)
    local ctx = self._decrypt_ctx
    if not ctx then
        return nil, "not inited for decrypt"
    end

    local len = ffi_new("size_t [1]")
    if C.EVP_PKEY_decrypt(ctx, nil, len, str, #str) <= 0 then
        return err()
    end

    local buf = self.buf
    if C.EVP_PKEY_decrypt(ctx, buf, len, str, #str) <= 0 then
        return err()
    end

    return ffi_str(buf, len[0])
end


function _M.encrypt(self, str)
    local ctx = self._encrypt_ctx
    if not ctx then
        return nil, "not inited for encrypt"
    end

    local len = ffi_new("size_t [1]")
    if C.EVP_PKEY_encrypt(ctx, nil, len, str, #str) <= 0 then
        return err()
    end

    local buf = self.buf
    if C.EVP_PKEY_encrypt(ctx, buf, len, str, #str) <= 0 then
        return err()
    end

    return ffi_str(buf, len[0])
end


function _M.sign(self, str)
    local md_ctx = self._sign_ctx
    if not md_ctx then
        return nil, "not inited for sign"
    end

    if C.EVP_DigestInit(md_ctx, self.md) <= 0 then
        return err()
    end

    if C.EVP_DigestUpdate(md_ctx, str, #str) <= 0 then
        return err()
    end

    local buf = self.buf
    local len = ffi_new("unsigned int[1]")
    if C.EVP_SignFinal(md_ctx, self.buf, len, self.pkey) <= 0 then
        return err()
    end

    return ffi_str(buf, len[0])
end


function _M.verify(self, str, sig)
    local md_ctx = self._verify_ctx
    if not md_ctx then
        return nil, "not inited for verify"
    end

    if C.EVP_DigestInit(md_ctx, self.md) <= 0 then
        return err()
    end

    if C.EVP_DigestUpdate(md_ctx, str, #str) <= 0 then
        return err()
    end

    local siglen = #sig
    local buf = siglen <= self.size and self.buf or ffi_new("unsigned char[?]", siglen)
    ffi_copy(buf, sig, siglen)
    if C.EVP_VerifyFinal(md_ctx, buf, siglen, self.pkey) <= 0 then
        return err()
    end

    return true
end


return _M
