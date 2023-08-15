#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int main()
{
  struct lua_State *L = luaL_newstate();
  luaL_openlibs(L);
  int ok = luaL_loadfile(L, "/export/hdq/workspace/lua/lua-5.4.6/ltest/pp.lua");
  if (ok == LUA_OK)
  {
    ok = lua_pcall(L, 0, 0, 0);
    if (ok != LUA_OK)
    {
      printf("pcall error:%s\n", lua_tostring(L, -1));
    }
  }
  else 
  {
    printf("load file error:%s\n", lua_tostring(L, -1));
  }
  lua_close(L);

  return 0;
}