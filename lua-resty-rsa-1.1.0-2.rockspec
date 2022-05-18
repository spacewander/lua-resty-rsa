package = 'lua-resty-rsa'
version = '1.1.0-2'
source = {
  url = 'https://github.com/spacewander/lua-resty-rsa.git',
  tag = 'v1.1.0'
}
description = {
  summary = 'RSA encrypt/decrypt & sign/verify for OpenResty/LuaJIT.',
  detailed = [[
    This library requires an nginx build 
    with OpenSSL, the ngx_lua module, 
    the LuaJIT 2.1.
  ]],
  homepage = 'https://github.com/spacewander/lua-resty-rsa',
  license = 'MIT'
}
dependencies = {
  'lua >= 5.1'
}
build = {
  type = 'builtin',
  modules = {
    ['resty.rsa'] = 'lib/resty/rsa.lua'
  }
}
