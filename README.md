Name
=============

lua-resty-rsa - RSA functions for LuaJIT

Status
======

This library is considered experimental.


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
    
	RSA_PUBLIC_KEY = [[
	-----BEGIN PUBLIC KEY-----
	MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8rPqGGsar+BWI7vAtaaDOqphy41j5186hCU9D
	cchV4HWiv0HvQ3KXAEqHfZiAHZSyMSRMmDZVnqJwCVWFvKUPqU1RsCPZ9Imk+9ZXVkM3DDdw74v/
	s6YMNx8cTuxybRCJUfOKbyC79cnHgmQqqkODv+EnprBtNKE4k8g90jNmbwIDAQAB
	-----END PUBLIC KEY-----
	    ]];
	local pub, err = resty_rsa:new({ public_key = RSA_PUBLIC_KEY,algorithm = algorithm,key_type="DER"})
	if not pub then
	    ngx.say("new rsa err: ", err)
	    return
	end
    
```


Methods
=======

To load this library,

1. you need to specify this library's path in ngx_lua's [lua_package_path](https://github.com/chaoslawful/lua-nginx-module#lua_package_path) directive. For example, `lua_package_path "/path/to/lua-resty-rsa/lib/?.lua;;";`.
2. you use `require` to load the library into a local Lua variable:

```lua
    local rsa = require "resty.rsa"
```

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
* `padding`
Specifies the padding mode when you want to encrypt/decrypt.
* `algorithm`
Specifies the digest algorithm when you want to sign/verify.
* `key_type`
Loading certificates Type  Default:pem Optional:DER.


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
encrypt for 50000 times cost : 1.2630000114441s
decrypt for 50000 times cost : 16.731999874115s
sign for 50000 times cost : 16.718000173569s
verify for 50000 times cost : 1.1089999675751s
```

when I run this script.
```
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

local resty_rsa = require "resty.rsa"
local algorithm = "SHA"

local pub, err = resty_rsa:new({
    public_key = RSA_PUBLIC_KEY,
    padding = resty_rsa.PADDING.RSA_PKCS1_PADDING,
    algorithm = algorithm,
})
if not pub then
    ngx.say("new rsa err: ", err)
    return
end

local priv, err = resty_rsa:new({
    private_key = RSA_PRIV_KEY,
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

for i = 1, num do
    encrypted, err = pub:encrypt(str)
    if not encrypted then
        ngx.say("failed to encrypt: ", err)
        return
    end
end

timer("encrypt")

for i = 1, num do
    decrypted = priv:decrypt(encrypted)
    if decrypted ~= str then
        ngx.say("decrypted not match")
        return
    end
end

timer("decrypt")

for i = 1, num do
    sig, err = priv:sign(str)
    if not sig then
        ngx.say("failed to sign:", err)
        return
    end
end

timer("sign")

for i = 1, num do
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
