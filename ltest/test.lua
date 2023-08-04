print(package.path)
print(package.cpath)

package.path = package.path .. ";/export/hdq/workspace/lua/lua-5.4.6/share/lua/5.4/?.lua" .. ";/export/hdq/workspace/lua/lua-5.4.6/share/lua/5.4/?/init.lua"
package.cpath = package.cpath .. ";/export/hdq/workspace/lua/lua-5.4.6/lib/lua/5.4/?.so"

require "socket.core"

socket = require("socket")
print(socket._VERSION)
--> LuaSocket 3.0.0
require("LuaPanda").start("127.0.0.1",8818);

local a = {}
a[1] = 454343
print("set next time")
a[1] = 116223


print("end")