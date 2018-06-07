Name
=============

lua-resty-rsa - RSA functions for LuaJIT

Status
======

This library is considered production ready.

Build status: [![Travis](https://travis-ci.org/doujiang24/lua-resty-rsa.svg?branch=master)](https://travis-ci.org/doujiang24/lua-resty-rsa)


Description
===========

This library requires an nginx build with OpenSSL,
the [ngx_lua module](http://wiki.nginx.org/HttpLuaModule), and [LuaJIT 2.0](http://luajit.org/luajit.html).


Synopsis
========

```lua
    # nginx.conf:

    lua_package_path "/path/to/lua-resty-rsa/lib/?.lua;;";

    server {
        location = /test {
            content_by_lua_file conf/test.lua;
        }
    }

    -- conf/test.lua:

    local resty_rsa = require "resty.rsa"
    local rsa_public_key, rsa_priv_key, err = resty_rsa:generate_rsa_keys(2048)
    if not rsa_public_key then
        ngx.say('generate rsa keys err: ', err)
    end

    ngx.say(rsa_public_key)
    --[[
    -----BEGIN RSA PUBLIC KEY-----
    MIIBCgKCAQEAuw4T755fepEyXTM66pzf6nv8NtnukQTMGnhmBFIFHp/P2vEpxjXU
    BBDUpzKkVFR3wuK9O1FNmRDAGNGYC0N/9cZNdhykA1NixJfKQzncN31VJTmNqJNZ
    W0x7H9ZGoh2aE0zCCZpRlC1Rf5rL0SVlBoQkn/n9LnYFwyLLIK5/d/y/NZVL6Z6L
    cyvga0zRajamLIjY0Dy/8YIwVV6kaSsHeRv2cOB03eam6gbhLGIz/l8wuJhIn1rO
    yJLQ36IOJymbbNmcC7+2hEQJP40qLvH7hZ1LaAkgQUHjfi8RvH2T1Jmce7XGPxCo
    Ed0yfeFz+pL1KeSWNey6cL3N5hJZE8EntQIDAQAB
    -----END RSA PUBLIC KEY-----
    ]]--

    ngx.say(rsa_priv_key)
    --[[
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAuw4T755fepEyXTM66pzf6nv8NtnukQTMGnhmBFIFHp/P2vEp
    xjXUBBDUpzKkVFR3wuK9O1FNmRDAGNGYC0N/9cZNdhykA1NixJfKQzncN31VJTmN
    qJNZW0x7H9ZGoh2aE0zCCZpRlC1Rf5rL0SVlBoQkn/n9LnYFwyLLIK5/d/y/NZVL
    6Z6Lcyvga0zRajamLIjY0Dy/8YIwVV6kaSsHeRv2cOB03eam6gbhLGIz/l8wuJhI
    n1rOyJLQ36IOJymbbNmcC7+2hEQJP40qLvH7hZ1LaAkgQUHjfi8RvH2T1Jmce7XG
    PxCoEd0yfeFz+pL1KeSWNey6cL3N5hJZE8EntQIDAQABAoIBAGim1ayIFK8EMQNH
    uDyui/Aqcc9WWky0PGTK23irUsXxb1708gQ89WNY70Cj6qBrqZ1VMb3QHPP4FSFN
    kh0rJJoi2g+ssm5R5r5KlhTKeFRrQInVC1Y3KhUUUwZa4aWtnhgSJ7Urq1yVhjU4
    K7PVkhH1OHBwcp/d1Bd6jd65AgPkY63P+WpcARJkClmQ1RhgoRwThyJdpKrV4/gO
    ha0AUGlJNRNvRwiZxP0zaI5C8RdrG96SnVpeYOcD0z/M1HVlkoYMXsXLKttwLfpK
    88Igtm6ZJwRpfuMF5VA+9hHaYGCBdGz0B/rMp2fc+EtrOavYQGrWIWi2RL1Qk6Rt
    BUyeTgECgYEA9anj4n/cak1MT+hbNFsL31mJXryl1eVNjEZj/iPMztpdS15CmFgj
    Kjr9UuintjSiK7Is43nZUWWyP1XQjRhVi2uP7PRIv92QNl/YteWD6tYCInJHKe2J
    QqYyZrElezsdayXb5DK6bi1UIYYji90g79N7x6pOR0UnQNQUXTv+Y8ECgYEAwuzl
    6Ez4BSXIIL9NK41jfNMa73Utfl5oO1f6mHM2KbILqaFE76PSgEeXDbOKdcjCbbqC
    KCGjwyPd+Clehg4vkYXTq1y2SQGHwfz7DilPSOxhPY9ND7lGbeNzDUK4x8xe52hd
    MWKdgqeqCK83e5D0ihzRiMah8dbxmlfLAOZ3sPUCgYEA0dT9Czg/YqUHq7FCReQG
    rg3iYgMsexjTNh/hxO97PqwRyBCJPWr7DlU4j5qdteobIsubv+kSEI6Ww7Ze3kWM
    u/tyAeleQlPTnD4d8rBKD0ogpJ+L3WpBNaaToldpNmr149GAktgpmXYqSEA1GIAW
    ZAL11UPIfOO6dYswobpevYECgYEApSosSODnCx2PbMgL8IpWMU+DNEF6sef2s8oB
    aam9zCi0HyCqE9AhLlb61D48ZT8eF/IAFVcjttauX3dWQ4rDna/iwgHF5yhnyuS8
    KayxJJ4+avYAmwEnfzdJpoPRpGI0TCovRQhFZI8C0Wb+QTJ7Mofmt9lvIUc64sff
    GD0wT/0CgYASMf708dmc5Bpzcis++EgMJVb0q+ORmWzSai1NB4bf3LsNS6suWNNU
    zj/JGtMaGvQo5vzGU4exNkhpQo8yUU5YbHlA8RCj7SYkmP78kCewEqxlx7dbcuj2
    LAPWpiDca8StTfEphoKEVfCPHaUk0MlBHR4lCrnAkEtz23vhZKWhFw==
    -----END RSA PRIVATE KEY-----
    ]]--

    local pub, err = resty_rsa:new({ public_key = rsa_public_key })
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

    local priv, err = resty_rsa:new({ private_key = rsa_priv_key })
    if not priv then
        ngx.say("new rsa err: ", err)
        return
    end
    local decrypted = priv:decrypt(encrypted)
    ngx.say(decrypted == "hello")

    local algorithm = "SHA256"
    local priv, err = resty_rsa:new({ private_key = rsa_priv_key, algorithm = algorithm })
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

    local pub, err = resty_rsa:new({ public_key = rsa_public_key, algorithm = algorithm })
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
```


Methods
=======

To load this library,

1. you need to specify this library's path in ngx_lua's [lua_package_path](https://github.com/chaoslawful/lua-nginx-module#lua_package_path) directive. For example, `lua_package_path "/path/to/lua-resty-rsa/lib/?.lua;;";`.
2. you use `require` to load the library into a local Lua variable:

```lua
    local rsa = require "resty.rsa"
```

generate_rsa_keys
---
`syntax: public_key, private_key, err = rsa:generate_rsa_keys(bits, in_pkcs8_fmt)`

 Generate rsa public key and private key by specifying the number of `bits`.
 The `in_pkcs8_fmt` is optional. If `in_pkcs8_fmt` is true, the generated keys are in PKCS#8 format, which start with `-----BEGIN PUBLIC` or `-----BEGIN PRIVATE`.
 Otherwise the generated keys are in PKCS#1 format, which start with `-----BEGIN RSA`.

new
---
`syntax: obj, err = rsa:new(opts)`

Creates a new rsa object instance by specifying an options table `opts`.

The options table accepts the following options:

* `public_key`
Specifies the public rsa key.
* `private_key`
Specifies the private rsa key.
* `password`
Specifies the password to read rsa key.
* `key_type`
Specifies the type of given key.

| `key_type` value | meaning |
| ------------------- | ------ |
| rsa.KEY_TYPE.PKCS1 | The input key is in PKCS#1 format(usually starts with `-----BEGIN RSA PUBLIC`), which is the default. |
| rsa.KEY_TYPE.PKCS8 | The input key is in PKCS#8 format(usually starts with `-----BEGIN PUBLIC`). |

```lua
-- creates a rsa object with pkcs#8 format of public key
local resty_rsa = require "resty.rsa"
local pub, err = resty_rsa:new({
    public_key = RSA_PKCS8_PUB_KEY,
    key_type = resty_rsa.KEY_TYPE.PKCS8,
})

-- creates a rsa object with pkcs#8 format of private key
local priv, err = resty_rsa:new({
    private_key = RSA_PKCS8_PASS_PRIV_KEY,
    key_type = resty_rsa.KEY_TYPE.PKCS8,
    -- you need to specify the password if the pkey is encrypted
    -- password = "foobar",
})
```

* `padding`
Specifies the padding mode when you want to encrypt/decrypt.
* `algorithm`
Specifies the digest algorithm when you want to sign/verify.

| `algorithm` value | meaning |
| ------------------- | ------ |
| md4/MD4/RSA-MD4/md4WithRSAEncryption | digest with `md4` |
| md5/MD5/RSA-MD5/md5WithRSAEncryption/ssl3-md5 | digest with `md5` |
| ripemd160/RIPEMD160/RSA-RIPEM160/ripemd160WithRSA/rmd160 | digest with `ripemd160` |
| sha1/SHA1/RSA-SHA1/sha1WithRSAEncryption/ssl3-sha1 | digest with `sha1` |
| sha224/SHA224/RSA-SHA224/sha224WithRSAEncryption | digest with `sha224` |
| sha256/SHA256/RSA-SHA256/sha256WithRSAEncryption | digest with `sha256` |
| sha384/SHA384/RSA-SHA384/sha384WithRSAEncryption | digest with `sha384` |
| sha512/SHA512/RSA-SHA512/sha512WithRSAEncryption | digest with `sha512` |

encrypt
----
`syntax: encrypted, err = obj:encrypt(str)`

decrypt
------
`syntax: decrypted, err = obj:decrypt(encrypted)`


sign
----
`syntax: signature, err = obj:sign(str)`

verify
------
`syntax: ok, err = obj:verify(str, signature)`


Performance
========

First of all, you are always recommended to cache the rsa object.

<http://wiki.nginx.org/HttpLuaModule#Data_Sharing_within_an_Nginx_Worker>

I got the result:
```
encrypt for 50000 times cost : 2.4110000133514s
decrypt for 50000 times cost : 57.196000099182s
sign for 50000 times cost : 59.169999837875s
verify for 50000 times cost : 1.8230001926422s
```

when I run this script.
```
local resty_rsa = require "resty.rsa"
local algorithm = "SHA256"

local rsa_public_key, rsa_priv_key, err = resty_rsa:generate_rsa_keys(2048)
if not rsa_public_key then
    ngx.say("generate rsa keys err: ", err)
    return
end

local pub, err = resty_rsa:new({
    public_key = rsa_public_key,
    padding = resty_rsa.PADDING.RSA_PKCS1_PADDING,
    algorithm = algorithm,
})
if not pub then
    ngx.say("new rsa err: ", err)
    return
end

local priv, err = resty_rsa:new({
    private_key = rsa_priv_key,
    padding = resty_rsa.PADDING.RSA_PKCS1_PADDING,
    algorithm = algorithm,
})
if not priv then
    ngx.say("new rsa err: ", err)
    return
end


local num = 5 * 10000

local str = "hello test"

local encrypted, decrypted, err, sig, verify

ngx.update_time()
local now = ngx.now()

local function timer(operation)
    ngx.update_time()
    local t = ngx.now()

    ngx.say(operation, " for ", num, " times cost : ", t - now, "s")
    now = t
end

for _ = 1, num do
    encrypted, err = pub:encrypt(str)
    if not encrypted then
        ngx.say("failed to encrypt: ", err)
        return
    end
end

timer("encrypt")

for _ = 1, num do
    decrypted = priv:decrypt(encrypted)
    if decrypted ~= str then
        ngx.say("decrypted not match")
        return
    end
end

timer("decrypt")

for _ = 1, num do
    sig, err = priv:sign(str)
    if not sig then
        ngx.say("failed to sign:", err)
        return
    end
end

timer("sign")

for _ = 1, num do
    verify, err = pub:verify(str, sig)
    if not verify then
        ngx.say("verify err: ", err)
        return
    end
end

timer("verify")
```


Author
======

Dejiang Zhu (doujiang24) <doujiang24@gmail.com>


Copyright and License
=====================

This module is licensed under the MIT license.

Copyright (C) 2014-2014, by Dejiang Zhu (doujiang24) <doujiang24@gmail.com>

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

See Also
========
* the ngx_lua module: http://wiki.nginx.org/HttpLuaModule
* the lua-resty-string: https://github.com/openresty/lua-resty-string
