#!/usr/local/openresty/bin/resty

local version = _VERSION:match("%d+%.%d+")
package.path = '/usr/local/kong/share/lua/' .. version .. '/?.lua;/usr/local/kong/share/lua/' .. version .. '/?/init.lua' .. package.path
package.cpath = '/usr/local/kong/lib/lua/' .. version .. '/?.so' .. package.cpath

-- force LuaSocket usage to resolve `/etc/hosts` until
-- supported by resty-cli.
-- See https://github.com/Mashape/kong/issues/1523
for _, namespace in ipairs({"cassandra", "pgmoon-mashape"}) do
  local socket = require(namespace .. ".socket")
  socket.force_luasocket(ngx.get_phase(), true)
end

require("kong.cmd.init")(arg)
