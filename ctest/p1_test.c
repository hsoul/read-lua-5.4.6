#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define HOMETOWN_LEVEL_ONE_MASK	0x0000000000000000
#define HOMETOWN_LEVEL_TWO_MASK	0x00001FFFFFFF8000
#define HOMETOWN_LEVEL_THREE_MASK 0x007FE00000000000
//获取家园的三级id
#define HOMETOWN_LEVEL_THREE_ID(hometown_id) ((hometown_id & HOMETOWN_LEVEL_THREE_MASK) >> 46)
//获取家园的二级id
#define HOMETOWN_LEVEL_TWO_ID(hometown_id) ((hometown_id & HOMETOWN_LEVEL_TWO_MASK) >> 16)
//获取家园的一级id
#define HOMETOWN_LEVEL_ONE_ID(hometown_id) 0
//获取zoneid
#define HOMETOWN_ZONEID(hometown_id) (hometown_id & ZONE_ID_MASK)

#define MAIL_ID_BITS 12
#define MAX_MAIL_ID  ((1 << MAIL_ID_BITS) - 1)
#define MAIL_ID_MASK (~((~(unsigned int)0)<<(MAIL_ID_BITS)))

int main()
{
  // struct lua_State *L = luaL_newstate();
  // luaL_openlibs(L);
  // int ok = luaL_loadfile(L, "/export/hdq/workspace/lua/lua-5.4.6/ltest/pp.lua");
  // if (ok == LUA_OK)
  // {
  //   ok = lua_pcall(L, 0, 0, 0);
  //   if (ok != LUA_OK)
  //   {
  //     printf("## pcall error:%s\n", lua_tostring(L, -1));
  //   }
  // }
  // else 
  // {
  //   printf("## load file error:%s\n", lua_tostring(L, -1));
  // }
  // lua_close(L);

  printf("%ld\n", HOMETOWN_LEVEL_THREE_ID(70370635032362));

  printf("%d\n", MAX_MAIL_ID);

  return 0;
}