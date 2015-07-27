# vi:ft=

use Test::Nginx::Socket::Lua;

repeat_each(2);
no_long_string();

plan tests => repeat_each() * (3 * blocks());

our $HttpConfig = <<'_EOC_';
    lua_package_path 'lib/?.lua;;';
    lua_package_cpath 'lib/?.so;;';
_EOC_

$ENV{TEST_NGINX_SHORT_PK_CONF} = '
local RSA_PUBLIC_KEY = [[
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBAJ9YqFCTlhnmTYNCezMfy7yb7xwAzRinXup1Zl51517rhJq8W0wVwNt+
mcKwRzisA1SIqPGlhiyDb2RJKc1cCNrVNfj7xxOKCIihkIsTIKXzDfeAqrm0bU80
BSjgjj6YUKZinUAACPoao8v+QFoRlXlsAy72mY7ipVnJqBd1AOPVAgMBAAE=
-----END RSA PUBLIC KEY-----
]]
local RSA_PRIV_KEY = [[
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCfWKhQk5YZ5k2DQnszH8u8m+8cAM0Yp17qdWZedede64SavFtM
FcDbfpnCsEc4rANUiKjxpYYsg29kSSnNXAja1TX4+8cTigiIoZCLEyCl8w33gKq5
tG1PNAUo4I4+mFCmYp1AAAj6GqPL/kBaEZV5bAMu9pmO4qVZyagXdQDj1QIDAQAB
AoGBAJega3lRFvHKPlP6vPTm+p2c3CiPcppVGXKNCD42f1XJUsNTHKUHxh6XF4U0
7HC27exQpkJbOZO99g89t3NccmcZPOCCz4aN0LcKv9oVZQz3Avz6aYreSESwLPqy
AgmJEvuVe/cdwkhjAvIcbwc4rnI3OBRHXmy2h3SmO0Gkx3D5AkEAyvTrrBxDCQeW
S4oI2pnalHyLi1apDI/Wn76oNKW/dQ36SPcqMLTzGmdfxViUhh19ySV5id8AddbE
/b72yQLCuwJBAMj97VFPInOwm2SaWm3tw60fbJOXxuWLC6ltEfqAMFcv94ZT/Vpg
nv93jkF9DLQC/CWHbjZbvtYTlzpevxYL8q8CQHiAKHkcopR2475f61fXJ1coBzYo
suAZesWHzpjLnDwkm2i9D1ix5vDTVaJ3MF/cnLVTwbChLcXJSVabDi1UrUcCQAmn
iNq6/mCoPw6aC3X0Uc3jEIgWZktoXmsI/jAWMDw/5ZfiOO06bui+iWrD4vRSoGH9
G2IpDgWic0Uuf+dDM6kCQF2/UbL6MZKDC4rVeFF3vJh7EScfmfssQ/eVEz637N06
2pzSvvB4xq6Gt9VwoGVNsn5r/K6AbT+rmewW57Jo7pg=
-----END RSA PRIVATE KEY-----
]]
';

$ENV{TEST_NGINX_PK_CONF} = '
local RSA_BAD_KEY = [[
-----BEGIN RSA PUBLIC KEY-----
badkey
-----END RSA PUBLIC KEY-----
]]
local RSA_PUBLIC_KEY = [[
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBAJ9YqFCTlhnmTYNCezMfy7yb7xwAzRinXup1Zl51517rhJq8W0wVwNt+
mcKwRzisA1SIqPGlhiyDb2RJKc1cCNrVNfj7xxOKCIihkIsTIKXzDfeAqrm0bU80
BSjgjj6YUKZinUAACPoao8v+QFoRlXlsAy72mY7ipVnJqBd1AOPVAgMBAAE=
-----END RSA PUBLIC KEY-----
]]
local RSA_PRIV_KEY = [[
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCfWKhQk5YZ5k2DQnszH8u8m+8cAM0Yp17qdWZedede64SavFtM
FcDbfpnCsEc4rANUiKjxpYYsg29kSSnNXAja1TX4+8cTigiIoZCLEyCl8w33gKq5
tG1PNAUo4I4+mFCmYp1AAAj6GqPL/kBaEZV5bAMu9pmO4qVZyagXdQDj1QIDAQAB
AoGBAJega3lRFvHKPlP6vPTm+p2c3CiPcppVGXKNCD42f1XJUsNTHKUHxh6XF4U0
7HC27exQpkJbOZO99g89t3NccmcZPOCCz4aN0LcKv9oVZQz3Avz6aYreSESwLPqy
AgmJEvuVe/cdwkhjAvIcbwc4rnI3OBRHXmy2h3SmO0Gkx3D5AkEAyvTrrBxDCQeW
S4oI2pnalHyLi1apDI/Wn76oNKW/dQ36SPcqMLTzGmdfxViUhh19ySV5id8AddbE
/b72yQLCuwJBAMj97VFPInOwm2SaWm3tw60fbJOXxuWLC6ltEfqAMFcv94ZT/Vpg
nv93jkF9DLQC/CWHbjZbvtYTlzpevxYL8q8CQHiAKHkcopR2475f61fXJ1coBzYo
suAZesWHzpjLnDwkm2i9D1ix5vDTVaJ3MF/cnLVTwbChLcXJSVabDi1UrUcCQAmn
iNq6/mCoPw6aC3X0Uc3jEIgWZktoXmsI/jAWMDw/5ZfiOO06bui+iWrD4vRSoGH9
G2IpDgWic0Uuf+dDM6kCQF2/UbL6MZKDC4rVeFF3vJh7EScfmfssQ/eVEz637N06
2pzSvvB4xq6Gt9VwoGVNsn5r/K6AbT+rmewW57Jo7pg=
-----END RSA PRIVATE KEY-----
]]

local RSA_PASS_PUBLIC_KEY = [[
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBAPnnuVFUH4N+1yB0YVc4dS8zZYvvcwlDabPgee+IZaoC19tLSIT7smM3
3uiEq9Jk5Y0mO+PljVGqCwB4MPDlQ1GUsX/77kWWzXf++MeelDY8jd43gJAvaQaN
bhVJg4SluyPIeCsmijrv0iZ9FMuDtGzjGXbuzbWSzAovFgIOg/dzAgMBAAE=
-----END RSA PUBLIC KEY-----
]]

local RSA_PASS_PRIV_KEY= [[
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,90BB636FD15F26B5BBE8BB197C17A007

IRxh4ZhuWPCQBd1w7S1Qg73sEh/tbxOyZuiaruo6L+tbOgStfo703vZeMdhB6bqe
fn2616SmzzFUNvZ9iSKRqP+pOPjwxcSAorWytvDaSrLq2EXfY1/b0rTlrSWzTbE/
2lCXzgi8OiAjE9r/2lqhsJU4BWvxVwxjXQNe9dq+xCNkNfVEEaHPv5/VgXWX3SZs
OvzCMF0i4aZ5iY0DO+6BvNx98C1VDrguFkBfxUp7YZqoeGZL2Vdcxe3M/M8SHCjW
n5Wh2wPJto/uqIv+d/WUjJzrqnessa5tGBaWvF48cRsHjMZIhSEgeQmctTGKqsc6
D6iEkcwbocMk2UMLwgXJpvtsFM4UzL0WW/jf21DYqfXF/wvZDEYfgKbtPEChzqWu
M0mUxE8SMSVA/qeF9FamwECcGkCplx7YE1pal7grZmuHTOCHGgVIw2UQH9Q/o1AN
5aG0N5aioEZErt6ox/AcdayGGwVyhesJmQd3p80PBxLb5dyFi8SPsx0A1EN2HIFJ
blYMmUbn4eQ8dsv+EPhhc+tbp33GQE34JzJLGSjq2DAQbO50YBbr+B5SA7G2Wtbu
5gi7WCfihH6nc4jAP3VNGp2nF9PZ86K8PBclePZDRaL168dEBnjKsuujw61m4x2r
sAE+U734LveoerlgRDxL2NVeIU3WR46qh/DCyL6oN5HKNGLAo239DOBTbYmaO+Xs
nPiSlearb/PMPJnq494/0QD5dTmXTEtiDDoM67wmF3G/8jaqbZ0zb1XtrvclMddU
RCxMyDrtIHNmD2uVFQefpY+6OiTaOsWYiK9FtPQwswue1NjPtXrClKt+gzJkCAd6
-----END RSA PRIVATE KEY-----
]]
';

#log_level 'warn';

run_tests();

__DATA__


=== TEST 1: RSA default hello
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local encrypted, err = pub:encrypt("hello")
            if not encrypted then
                ngx.say("failed to encrypt: ", err)
                return
            end
            ngx.say("encrypted length: ", #encrypted)

            local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY })
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end
            local decrypted = priv:decrypt(encrypted)
            ngx.say(decrypted == "hello")

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
encrypted length: 128
true
--- no_error_log
[error]


=== TEST 2: RSA bad pkey
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local pub, err = resty_rsa:new({ public_key = RSA_BAD_KEY })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local encrypted, err = pub:encrypt("hello")
            if not encrypted then
                ngx.say("failed to encrypt: ", err)
                return
            end
            ngx.say("encrypted length: ", #encrypted)

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
new rsa err: bad base64 decode
--- no_error_log
[error]


=== TEST 3: RSA different padding
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY, padding = resty_rsa.PADDING.RSA_PKCS1_PADDING })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local encrypted, err = pub:encrypt("hello")
            if not encrypted then
                ngx.say("failed to encrypt: ", err)
                return
            end
            ngx.say("encrypted length: ", #encrypted)

            local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY, padding = resty_rsa.PADDING.RSA_PKCS1_OAEP_PADDING })
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end
            local decrypted = priv:decrypt(encrypted)
            ngx.say(decrypted == "hello")

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
encrypted length: 128
false
--- no_error_log
[error]


=== TEST 4: RSA data size
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            for name, padding in pairs(resty_rsa.PADDING) do
                local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY, padding = padding })
                if not pub then
                    ngx.say("new rsa err: ", err)
                    return
                end

                local s, max_len
                for i = 1, 130 do
                    s = (s or "") .. "p"
                    max_len = #s
                    local encrypted, err = pub:encrypt(s)
                    if not encrypted then
                        break
                    end
                end
                ngx.say(name, ":", max_len - 1)
            end

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
RSA_PKCS1_PADDING:117
RSA_NO_PADDING:0
RSA_SSLV23_PADDING:117
RSA_PKCS1_OAEP_PADDING:86
--- no_error_log
[error]


=== TEST 5: RSA RSA_NO_PADDING
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local pub, err = resty_rsa:new( { public_key = RSA_PUBLIC_KEY, padding = resty_rsa.PADDING.RSA_NO_PADDING })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end

            local s = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
            local encrypted, err = pub:encrypt(s)
            if not encrypted then
                ngx.say("failed to encrypt: ", err)
                return
            end
            ngx.say("encrypted length: ", #encrypted)

            local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY, padding = resty_rsa.PADDING.RSA_NO_PADDING})
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end
            local decrypted = priv:decrypt(encrypted)

            ngx.say(decrypted == s)

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
encrypted length: 128
true
--- no_error_log
[error]


=== TEST 6: RSA pass phrase
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local pub, err = resty_rsa:new({ public_key = RSA_PASS_PUBLIC_KEY })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local encrypted, err = pub:encrypt("hello")
            if not encrypted then
                ngx.say("failed to encrypt: ", err)
                return
            end
            ngx.say("encrypted length: ", #encrypted)

            local priv, err = resty_rsa:new({ private_key = RSA_PASS_PRIV_KEY, password = "foobar"} )
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end
            local decrypted = priv:decrypt(encrypted)
            ngx.say(decrypted == "hello")

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
encrypted length: 128
true
--- no_error_log
[error]



=== TEST 7: RSA sign
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_SHORT_PK_CONF
            local resty_rsa = require "resty.rsa"
            local algorithm = "SHA"
            local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY, algorithm = algorithm })
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end

            local str = "hello"
            local sig, err = priv:sign(str)
            if not sig then
                ngx.say("failed to sign:", err)
                return
            end
            ngx.say("sig length: ", #sig)

            local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY, algorithm = algorithm })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local verify, err = pub:verify(str, sig)
            if not verify then
                ngx.say("verify err: ", err)
                return
            end
            ngx.say(verify)

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
sig length: 128
true
--- no_error_log
[error]



=== TEST 8: RSA sign: wrong with different signature algorithm
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_PK_CONF
            local resty_rsa = require "resty.rsa"
            local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY, algorithm = "RSA-MD5" })
            if not priv then
                ngx.say("new rsa err: ", err)
                return
            end

            local str = "hello"
            local sig, err = priv:sign(str)
            if not sig then
                ngx.say("failed to sign:", err)
                return
            end
            ngx.say("sig length: ", #sig)

            local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY, algorithm = "RSA-SHA1" })
            if not pub then
                ngx.say("new rsa err: ", err)
                return
            end
            local verify, err = pub:verify(str, sig)
            if not verify then
                ngx.say("verify err: ", err)
                return
            end
            ngx.say(verify)

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
sig length: 128
verify err: algorithm mismatch
--- no_error_log
[error]



=== TEST 9: RSA sign with different algorithm
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            $TEST_NGINX_SHORT_PK_CONF
            local resty_rsa = require "resty.rsa"

            local algorithms = {
                "MD4",
                "MD5",
                "RIPEMD160",
                "SHA",
                "SHA1",
                "SHA224",
                "SHA256",
                "SHA384",
                "SHA512",
                "md4",
                "md5",
                "ripemd160",
                "sha",
                "sha1",
                "sha224",
                "sha256",
                "sha384",
                "sha512",
                "RSA-MD4",
                "RSA-MD5",
                "RSA-RIPEMD160",
                "RSA-SHA",
                "RSA-SHA1",
                "RSA-SHA1-2",
                "RSA-SHA224",
                "RSA-SHA256",
                "RSA-SHA384",
                "RSA-SHA512",
                "md4WithRSAEncryption",
                "md5WithRSAEncryption",
                "ripemd",
                "ripemd160WithRSA",
                "rmd160",
                "sha1WithRSAEncryption",
                "sha224WithRSAEncryption",
                "sha256WithRSAEncryption",
                "sha384WithRSAEncryption",
                "sha512WithRSAEncryption",
                "shaWithRSAEncryption",
                "ssl2-md5",
                "ssl3-md5",
                "ssl3-sha1",
            }
            local count = 0
            for i, algorithm in pairs(algorithms) do
                local priv, err = resty_rsa:new({ private_key = RSA_PRIV_KEY, algorithm = algorithm })
                if not priv then
                    ngx.say("new rsa err: ", err, "; with algorithm: ", algorithm)
                    return
                end

                local str = "hello"
                local sig, err = priv:sign(str)
                if not sig then
                    ngx.say("failed to sign:", err, "; with algorithm: ", algorithm)
                    return
                end

                local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY, algorithm = algorithm })
                if not pub then
                    ngx.say("new rsa err: ", err)
                    return
                end
                local verify, err = pub:verify(str, sig)
                if not verify then
                    ngx.say("verify err: ", err)
                    return
                end

                collectgarbage()

                count = count + 1
            end

            ngx.say(count == #algorithms)
        ';
    }
--- request
GET /t
--- response_body
true
--- no_error_log
[error]
