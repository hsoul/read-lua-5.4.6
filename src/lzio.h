/*
** $Id: lzio.h $
** Buffered streams
** See Copyright Notice in lua.h
*/

#ifndef lzio_h
#define lzio_h

#include "lua.h"

#include "lmem.h"

#define EOZ (-1) /* end of stream */

typedef struct Zio ZIO;

#define zgetc(z) (((z)->n--) > 0 ? cast_uchar(*(z)->p++) : luaZ_fill(z)) // 缓冲区中还有字符，直接返回，否则调用 luaZ_fill() 填充缓冲区并返回缓冲区的第一个字符

typedef struct Mbuffer
{
  char *buffer;
  size_t n; // 缓冲区中的字符数
  size_t buffsize; // 缓冲区大小
} Mbuffer;

#define luaZ_initbuffer(L, buff) ((buff)->buffer = NULL, (buff)->buffsize = 0)

#define luaZ_buffer(buff) ((buff)->buffer)
#define luaZ_sizebuffer(buff) ((buff)->buffsize)
#define luaZ_bufflen(buff) ((buff)->n)

#define luaZ_buffremove(buff, i) ((buff)->n -= (i))
#define luaZ_resetbuffer(buff) ((buff)->n = 0)

#define luaZ_resizebuffer(L, buff, size)                                          \
  ((buff)->buffer = luaM_reallocvchar(L, (buff)->buffer, (buff)->buffsize, size), \
   (buff)->buffsize = size)

#define luaZ_freebuffer(L, buff) luaZ_resizebuffer(L, buff, 0)

LUAI_FUNC void luaZ_init(lua_State *L, ZIO *z, lua_Reader reader, void *data);
LUAI_FUNC size_t luaZ_read(ZIO *z, void *b, size_t n); /* read next n bytes */

/* --------- Private Part ------------------ */

struct Zio
{
  size_t n;          /* bytes still unread */
  const char *p;     // 一块buffer中的指针 /* current position in buffer */
  lua_Reader reader; /* reader function */
  void *data;        // 被加载的对象 /* additional data */
  lua_State *L;      /* Lua state (for reader) */
};

LUAI_FUNC int luaZ_fill(ZIO *z);

#endif
