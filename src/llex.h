/*
** $Id: llex.h $
** Lexical Analyzer
** See Copyright Notice in lua.h
*/

#ifndef llex_h
#define llex_h

#include <limits.h>

#include "lobject.h"
#include "lzio.h"

/*
** Single-char tokens (terminal symbols) are represented by their own
** numeric code. Other tokens start at the following value.
*/
#define FIRST_RESERVED (UCHAR_MAX + 1)

#if !defined(LUA_ENV)
  #define LUA_ENV "_ENV"
#endif

/*
 * WARNING: if you change the order of this enumeration,
 * grep "ORDER RESERVED"
 */
enum RESERVED
{
  /* terminal symbols denoted by reserved words */
  TK_AND = FIRST_RESERVED, // and
  TK_BREAK,                // break
  TK_DO,                   // do
  TK_ELSE,                 // else
  TK_ELSEIF,               // elseif
  TK_END,                  // end
  TK_FALSE,                // false
  TK_FOR,                  //  for
  TK_FUNCTION,             // function
  TK_GOTO,                 // goto
  TK_IF,                   // if
  TK_IN,                   // in
  TK_LOCAL,                // local
  TK_NIL,                  // nil
  TK_NOT,                  // not
  TK_OR,                   // or
  TK_REPEAT,               // repeat
  TK_RETURN,               // return
  TK_THEN,                 // then
  TK_TRUE,                 // true
  TK_UNTIL,                // until
  TK_WHILE,                // while
  /* other terminal symbols */
  TK_IDIV,    // // TK_IDIV 是 Lua 中的整数除法操作符，表示两个数相除并向下取整到最接近的整数。举个例子，5 // 2 的结果是 2。注意，这个操作符只能用于整数，如果其中一个操作数是浮点数，Lua 会将其转换为整数再进行运算。
  TK_CONCAT,  // ..
  TK_DOTS,    // ...
  TK_EQ,      // ==
  TK_GE,      // >=
  TK_LE,      // <=
  TK_NE,      // ~=
  TK_SHL,     // <<
  TK_SHR,     // >> shift right 算数：+、-、*、/、%、^、～、&、|、＜＜、>>。由于＜＜和>>无法使用单独的字符来表示token的类型，因此它们使用单独的枚举值：TK_SHL和TK_SHR。其他算术符的ASCII值就是token的类型值。
  TK_DBCOLON, // ::
  TK_EOS,     // end of stream
  TK_FLT,     // float
  TK_INT,     // integer
  TK_NAME,    // name
  TK_STRING   // string "xxx"
};

/* number of reserved words */
#define NUM_RESERVED (cast_int(TK_WHILE - FIRST_RESERVED + 1))

typedef union
{
  lua_Number r;
  lua_Integer i;
  TString *ts;
} SemInfo; /* semantics information */

typedef struct Token
{
  int token;
  SemInfo seminfo;
} Token;

/* state of the lexer plus state of the parser when shared by all functions */
typedef struct LexState // 词法分析器
{
  int current;          /* current character (charint) */
  int linenumber;       /* input line counter */
  int lastline;         /* line of last token 'consumed' */
  Token t;              /* current token */
  Token lookahead;      // 提前获取的token，如果它存在（不为TK_EOS）,那么词法分析器调用next函数时，它的值直接被获取 /* look ahead token */
  struct FuncState *fs; /* current function (parser) */
  struct lua_State *L;  /* */
  ZIO *z;               /* input stream */
  Mbuffer *buff;        // 保留字本身以及TK_NAME、TK_FLOAT、TK_INT和TK_STRING的值，由于不止由一个字符组成，因此token在被完全识别之前，读取出来的字符应当存在buff结构中，当词法分析器攒够一个完整token时，则将其复制到Seminfo.s /* buffer for tokens */
  Table *h;             // 常量缓存表。用于缓存lua代码中的常量，以加快编译时的常量查找 /* to avoid collection/reuse strings */
  struct Dyndata *dyd;  // 语法分析过程中，存放local变量信息的结构 /* dynamic structures used by the parser */
  TString *source;      /* current source name */
  TString *envn;        /* environment variable name */
} LexState;

LUAI_FUNC void luaX_init(lua_State *L);
LUAI_FUNC void luaX_setinput(lua_State *L, LexState *ls, ZIO *z, TString *source, int firstchar);
LUAI_FUNC TString *luaX_newstring(LexState *ls, const char *str, size_t l);
LUAI_FUNC void luaX_next(LexState *ls); // 获取下一个token，如果lookahead中存在token，则直接从lookahead中获取，否则调用llex函数获取
LUAI_FUNC int luaX_lookahead(LexState *ls); // 提前获取下一个token的信息并暂存到lookahead中
LUAI_FUNC l_noret luaX_syntaxerror(LexState *ls, const char *s);
LUAI_FUNC const char *luaX_token2str(LexState *ls, int token);

#endif
