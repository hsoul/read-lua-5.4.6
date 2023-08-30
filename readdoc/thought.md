upvalue具体是怎么生成的。实际上，查阅了源码后，不难发现，upvalue实际上是在编译时确定（位置信息，和外层函数的关联等），在运行时生成，什么意思呢？
意思就是，在编译脚本阶段，就要确定lua函数的upvalue有哪些，在哪里。在虚拟机运行阶段，再去生成对应的upvalue。
实际上，用来表示upvalue的有两个数据结构，一个是编译时期，存储upvalue信息的Upvaldesc（这个结构并不存储upvalue的实际值，只是用来标记upvalue的位置信息），还有一个是在运行期，实际存储upvalue值的UpVal结构。


由于前面章节，已经详细介绍过Proto的结构了，之类不再赘述，本章只关注Proto和Upvalue之间的关系。
我们都知道，lua脚本的编译信息，会被存储到Proto结构实例之中，当一个lua函数的某个变量，不是local变量时，我们希望获取它的值，实际上就是要查找这个变量的位置，如果local列表中找不到，则进入到如下流程： 
    1 到自己的upvaldesc列表中，根据变量名查找，是否存在某个upvalue存在，如果存在则使用它，否则进入下一步
    2 到外层函数，查找local变量，如果找到，那么将它作为自己的upvalue，否则查找它的upvaldesc表，找到就将其生成为自己的upvalue，否则进入外层函数，重复这一步
    3 如果一直到top-level函数都找不到，那么表示这个upvalue不存在，此时需要去_ENV中查找

这里，我们需要通过一个例子，来理解这个流程，需要注意的是，这个过程，是在lua脚本的编译阶段进行的：  -- test.lua


可能有读者会问，那yyy函数没做处理吗？答案是是的，因为我们没有调用xxx函数，因此yyy变量的赋值操作，也就不会进行，并且该LClosure实例也不会被创建，xxx函数会被创建，是因为它是在top-level函数里定义的，大家可以回顾一下上面替换成等式的例子。

就是一个函数的upvalue，一直溯源下去，最终的源头，要么是某个外层函数的local变量，要么就是最外层函数的_ENV

创建LClosure时机 = {
    1 = 定义函数 = {
        function xxx()

        end

        相当于 xxx = function() end
    }

    2 = return function 时 = {
        function xxx() 
            return function() end -- 此处
        end

        每次调用xxx函数，都会创建一个新的匿名LClosure实例
    }
}

在一门语言中什么是表达式？
表达式最终能够演变成一个值，并且这个值可以被赋值到一个变量中。符合这个条件的就是表达式，否则就是语句。
语句则是一系列操作的集合，它包含一系列的表达式或者其他语句。
语句是一门语言中单独的一个单元，一门语言中有不同的语句类别，并且这些有限类别的语句组成的序列构成一门语言的逻辑代码。
表达式（expression）
    a = 1
    b  = true
    c = nil
    d = 1 + 2 * (3 - 4)
    左边的a、b、c、d是变量，右边的1、1+2*（3-4）、true和nil最终能够演变成一个值，并且可以赋值给左边的变量，因此它们是表达式。
    而每一行的赋值语句，则是单独的语句。
语句（statement）
    do block end
    while exp do block end
    repeat block until exp
    if exp then block end
    for name = exp, exp [, exp] do block end
    for namelist in explist do block end
    function funcname funcbody
    local function Name funcbody
    local namelist [ = explist ]
    varlist = explist
    functioncall
    这里需要注意的是，在Lua中，function（函数）是个单独的类型，因此函数语句是可以直接被赋值到某个变量的。从某种意义上来说，它也是表达式，但是传统定义上，比如C语言，这些都是作为语句存在的。


在逗号表达式中，整个表达式的返回值是最后一个表达式的返回值。例如：
    int a = (1, 2, 3, 4, 5);
上面的代码中，逗号表达式(1, 2, 3, 4, 5)在计算时依次计算每个子表达式，但最终返回的是最后一个表达式的值5

词法分析
语法分析

lua执行脚本流程
    1 编译
    2 执行

编译过程中查询变量的过程(singlevar)
    1 从当前函数的局部变量列表中查找，如果找到则返回
    2 第一步没找到，从当前函数的upvalue列表中查找，如果找到则返回
    3 第三步没找到，向上一级函数重复1、2步骤继续查找，如果找到返回
    4 重复第三步直至顶层函数仍未找到变量，此时从chrunk的环境中查找（_ENV, _ENV默认是＿Ｇ），这一步不管找没找到都标记成是环境的的值了，运行时才会真的去根据变量取查找，如果未找到会报错

编译流程 = {
    编译型语言 = {
        编译前端 = { -- 前一步的输出是后一步的输入
            1 = 词法分析 -> token
            2 = 语法分析 -> 抽象语法树？
            3 = 中间表示生成器 -> 中间表示
        }
        编译后端 = {
            4 = 代码生成器 -> 目标代码
            5 = 目标代码优化器 -> 目标代码
        }
    }
    lua = {
        1 = 词法分析 -> token
        2 = 语法分析 -> 目标代码
    }
}

Lua的语法分析器是单趟语法分析器（One-Pass Parser），即将Lua脚本源码直接编译成Lua虚拟机指令，而不生成抽象语法树。这样做的目的是为了尽最大努力提升Lua内置编译器的编译效率。

在编译器中什么是token？token是一门语言中能够被识别的最小单元。

在完成文本加载以后，需要从中逐个地获取有效token，而获取token的操作是通过词法分析器里的一个函数来实现的，可以假设它叫next函数。

如果代码是存放在文本中的，那么词法分析器先要将文本中的代码加载到内存中，被加载到内存的文本内容实际上就是一个字符序列。词法分析器需要对这个字符序列进行进一步的提取工作。一次只能获取一个有效的token，获取token的函数由词法分析器提供，比如例子里的next函数。其次是token，其能够表示的内容非常丰富。它可以表示标识符、字符串、ASCII字符和文本结束的EOF标识。正因为token能够表示的内容相当丰富，因此需要对token进行分类。实际上，一个token既要表明它是什么类型的，还要表明自己包含的内容是什么。

在众多的类型中，只有几种需要保存值到token实例中，它们分别是TK_NAME、TK_FLOAT、TK_INT和TK_STRING，于是Seminfo结构就派上用场了。Seminfo结构是一个union类型，它包含三个域：一个是lua_Number类型，用于存放浮点型数据；一个是lua_Integer类型，用于存放整型数据；一个是TString类型，用于存放标识符和字符串的值。

lexical adj 词法的；词汇的；词法分析的
token n. 记号；标记；象征；代币

要实现一门语言的编译器，首先要弄清楚这门语言的语法。
下面是其中的一些规则。
1）“::=”左边的是起始符，可以被右边的符号取代。起始符、“::=”和其右边的终结符或非终结符共同构成一个产生式。
2）“{}”内的表达式可以出现0次或者多次。
3）“[]”内的表达式可以出现0次或者1次。
4）使用“|”隔开的表达式只有一个会被选中，用来取代“::=”左边的符号。
5）使用‘和’包起来的符号（包括前面几条具有特别功能的符号），仅仅代表它是语句里不可继续被分割的部分，可以将其视为终结符，不能再分解。
6）Name表示标识符，可以将其分解为下画线、字母和数字（首字符不能是数字）的非终结符。
7）LiteralString表示字符串，可以将其分解为处于‘和’或者“和”之间的任意字符组合的非终结符。
8）Numeral表示数值，可以将其分解为数字或与小数点组成的非终结符（包含浮点数和整数）。

Lua脚本内部的代码本质上就是一个chunk。
chunk在编译后，本质上也是一个Lua函数对象。
一般一个Lua函数对应一个Proto实例，在编译过程中，一个Lua函数则对应一个FuncState结构。
FuncState结构实例只在编译期存在。

token就是文件中不能被分割的最小字符单元

描述指令行为的函数和符号，分别是R函数、Kst函数、RK函数、PC变量和上值。
    R函数代表获取Lua虚拟机上的寄存器，而Lua虚拟机的寄存器，是函数被调用时用虚拟栈上的空间来表示的。
    Kst函数的作用则是表示获取Lua函数中的常量。在Lua中，常量指整型数值（如123）、浮点型数值（如123.456）、nil值、字符串（如"hello"）和布尔值（如true和false）。这些常量会按照出现的顺序被写入到函数的常量表中。
        全局变量赋值语句中的左值和右值（当且仅当是常量时）均会存入常量表
        局部变量的赋值语句中，局部变量名不会写入常量表k，但是赋值语句的右值是常量时会写入
        局部变量赋值为布尔型常量时不会存入常量表k
        如果调用的是全局函数，那么函数名和参数列表会写入常量表中
        局部函数的调用，除了函数名没在常量表中，其他的情况和全局函数调用的类似
    Kst函数的作用就是返回当前被调用函数中常量表的常量值. 常量表下标从1开始，因此当调用Kst（n）时（n为自然数），它实际上是取Proto.k[n-1]的值。
    RK函数其本质是R函数和Kst函数的结合。RK函数的具体功能是由它的参数决定的，使用RK函数的方式如下所示。
        RK(x) x为非负整数
        当x的值小于256时，RK（x）实际上就是R（x）。当x的值大于等于256时，RK（x）实际就是Kst（x-256）。RK函数能够极大地方便描述虚拟机指令的逻辑。
    有一些指令的描述里使用了PC这个变量，它所表示的是下一个要执行指令的地址。
        虚拟机要执行的指令实际上是存储在Proto结构中的code列表里的，PC变量本质就是savedpc指针，PC变量自增实际上就是表示savedpc++操作。

指令 = {
    OP_MOVE = {
        OP_MOVE A B; R(A) := R(B) -- 将寄存器R(B)上的值赋值到寄存器R(A)中
        OP_MOVE指令是iABC模式，该指令会按照iABC模式进行解析。A和B的值均是非负整数值，该指令中C域未被使用
        由于A域是8bit，因此A的取值范围在0～255。因为Lua函数被调用时，虚拟栈空间均可作为寄存器使用，因此虚拟栈空间的最大尺寸是256。而局部变量是通过虚拟机指令赋值到虚拟栈上的，因此单个函数定义的局部变量数目，理论上不能超过256个。
    }
    OP_LOADK = {
        OP_LOADK A Bx; R(A) := Kst(Bx) -- 将常量表中第Bx个常量赋值到寄存器R(A)中
        OP_LOADK是iABx模式。Bx是18bit的非负整数，因此Bx的范围是0～262143。Kst（Bx）取的是常量表的值，因此常量表最大尺寸实际是262144。
    }
    OP_LOADBOOL = {
        OP_LOADBOOL A B C; R(A) := (Bool)B; if (C) PC++ -- 将B的值赋值到R(A)中，且如果C为真，则PC自增1
        OP_LOADBOOL是iABC模式。编译器将布尔值直接编入指令中。B、C的值是0或者1. 如果C为真，则PC自增1，也就是跳过下一条指令，执行下下个指令。
    }
    OP_LOADNIL = {
        OP_LOADNIL A B; R(A), R(A + 1), ... R(A + B) := nil -- 从寄存器R(A)开始到寄存器R(A + B)的值，全部赋值为nil
        OP_LOADNIL是iABC模式。其中C域没有使用，A和B均是非负整数
    }
    OP_GETUPVAL = {
        OP_GETUPVAL A B; R(A) := UpValue[B] -- 将当前调用的Lua函数的第B个upvalue的值赋值到寄存器R(A)中
        OP_GETUPVAL是iABC模式。其中C域没有使用，A和B均是非负整数
    }
    OP_GETTABUP = {
        OP_GETTABUP A B C; R(A) := UpValue[B][RK(C)] -- 将当前调用的Lua函数的第B个upvalue的值取出，它必定是一个表，并且使用RK(C)获取该表的键，最终将键对应的值赋值给寄存器R(A)
        OP_GETTABUP指令是iABC模式。这个指令本质是先获得upvalue[B]的值，这个值必定是Lua表，否则虚拟机会抛出异常。然后通过RK（C）获取要访问表的键，最后再将最后的值赋值给寄存器R（A）。当C的值小于256时，RK（C）实际就是R（C），当C的值大于等于256时，RK（C）实际就是Kst（C-256）

        fake_code = {
            t = upvalue[B]
            if not istable(t) then
                throw error
            end
            key = RK(C)
            R(A) = t[key]
        }
    }
    OP_GETTABLE = {
        OP_GETTABLE A B C; R(A) := R(B)[RK(C)] -- 将寄存器R(B)上的值取出，它必定是一个表，并且使用RK(C)获取该表的键，最终将键对应的值赋值给寄存器R(A)
        OP_GETTABLE指令是iABC模式。其中R（B）寄存器内的值必定是一个Lua表，否则Lua虚拟机会抛出异常

        fake_code = {
            t = R(B)
            if not istable(t) then
                throw error
            end
            key = RK(C)
            R(A) = t[key]
        }
    }
    OP_SETTABUP = {
        OP_SETTABUP A B C; UpValue[A][RK(B)] := RK(C) -- 获取第A个upvalue,它必定是一个Lua表，然后使用RK(B)获取该表中的键，并将RK(C)的值赋值赋值到该键对应的值里
        OP_SETTABUP指令是iABC模式

        fake_code = {
            t = upvalue[A]
            if not istable(t) then
                throw error
            end
            t[RK(B)] = RK(C)
        }
    }
    OP_SETUPVAL = {
        OP_SETUPVAL A B; UpValue[B] := R(A) -- 将寄存器R(A)的值赋值给当前调用的Lua函数的第B个upvalue
        OP_SETUPVAL指令是iABC模式, 其中C域没有使用
    }
    OP_SETTABLE = {
        OP_SETTABLE A B C; R(A)[RK(B)] := RK(C) -- 寄存器R(A)上的值必定是一个Lua表。RK(B)是R(A)的key，RK(C)将作为该key对应的值
        OP_SETTABLE指令是iABC模式

        fake_code = {
            t = R(A)
            if not istable(t) then
                throw error
            end
            t[RK(B)] = RK(C)
        }
    }
    OP_NEWTABLE = {
        OP_NEWTABLE A B C; R(A) := {} (size = B,C) -- 创建一个新表，array部分的大小为B，哈希部分的大小为C，并将该表赋值给寄存器R(A)
        OP_NEWTABLE指令是iABC模式。其中B和C域均是非负整数，B域表示该表的数组部分的大小，C域表示该表的哈希部分的大小
    }
    OP_SELF = {
        OP_SELF A B C; R(A + 1) := R(B); R(A) := R(B)[RK(C)] -- 将寄存器R(B)的值复制到寄存器R(A + 1)中，R(B)中的值必定是一个表，最后通过RK(C)获取该表的键，将lua表对应的值赋值给寄存器R(A)
        OP_SELF指令是iABC模式。这个指令有些特别，它一般不能作为第一个指令存在，而是先要有包含目标函数的表存入栈中，才能继续操作。t表示OP_SELF指令的前一个指令压入栈中的Lua表。接着会将t[RK（C）]的值赋值到R（A）中，t[RK（C）]必定是个函数
    }
    OP_ADD = {
        OP_ADD A B C; R(A) := RK(B) + RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值相加，然后将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是数值类型
        OP_ADD指令是iABC模式
    }
    OP_SUB = {
        OP_SUB A B C; R(A) := RK(B) - RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值相减，然后将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是数值类型
        OP_SUB指令是iABC模式
    }
    OP_MUL = {
        OP_MUL A B C; R(A) := RK(B) * RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值相乘，然后将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是数值类型
        OP_MUL指令是iABC模式
    }
    OP_MOD = {
        OP_MOD A B C; R(A) := RK(B) % RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值取模，然后将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是数值类型
        OP_MOD指令是iABC模式
    }
    OP_POW = {
        OP_POW A B C; R(A) := RK(B) ^ RK(C) -- 以RK(B)为底数RK(C)为指数进行指数运算，并将结果赋值到寄存器R(A)中. RK(B)和R(C)一般要求同时是数值类型
        OP_POW指令是iABC模式
    }
    OP_DIV = {
        OP_DIV A B C; R(A) := RK(B) / RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值相除，然后将结果赋值给寄存器R(A). R(C)的值不能为0
        OP_DIV指令是iABC模式
    }
    OP_IDIV = {
        OP_IDIV A B C; R(A) := RK(B) // RK(C) -- 尝试将寄存器RK(B)和寄存器RK(C)上的值同时转换成整数，然后进行整数除法，并将结果赋值给寄存器R(A).如果RK(B)和RK(C)不能同时转换成整型，那么它们会尝试被转换成浮点类型再进行计算。 R(C)的值不能为0
        OP_IDIV指令是iABC模式
    }
    OP_BAND = {
        OP_BAND A B C; R(A) := RK(B) & RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值进行按位与运算，并将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是整数类型
        OP_BAND指令是iABC模式
    }
    OP_BOR = {
        OP_BOR A B C; R(A) := RK(B) | RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值进行按位或运算，并将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是整数类型
        OP_BOR指令是iABC模式
    }
    OP_BXOR = {
        OP_BXOR A B C; R(A) := RK(B) ~ RK(C) -- 将寄存器RK(B)和寄存器RK(C)上的值进行按位异或运算，并将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是整数类型
        OP_BXOR指令是iABC模式
    }
    OP_SHL = {
        OP_SHL A B C; R(A) := RK(B) << RK(C) -- 将寄存器RK(B)的值向左移RK(C)位，并将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是整数类型
        OP_SHL指令是iABC模式
    }
    OP_SHR = {
        OP_SHR A B C; R(A) := RK(B) >> RK(C) -- 将寄存器RK(B)的值向右移RK(C)位，并将结果赋值给寄存器R(A). RK(B)和R(C)一般要求同时是整数类型
        OP_SHR指令是iABC模式
    }
    OP_UNM = {
        OP_UNM A B; R(A) := -R(B) -- 将寄存器R(B)上的值取负，并将结果赋值给寄存器R(A). R(B)一般要求是数值类型
        OP_UNM指令是iABC模式
    }
    OP_NOT = {
        OP_NOT A B; R(A) := not R(B) -- 将寄存器R(B)上的值取反，并将结果赋值给寄存器R(A). 
        OP_NOT指令是iABC模式
    }
    OP_LEN = {
        OP_LEN A B; R(A) := length of R(B) -- 将寄存器R(B)上的值的长度赋值给寄存器R(A). R(B)一般要求是字符串或者表类型
        OP_LEN指令是iABC模式
    }
    OP_CONCAT = {
        OP_CONCAT A B C; R(A) := R(B).. ... ..R(C) -- 将寄存器R(B)到寄存器R(C)上的值进行连接，并将结果赋值给寄存器R(A).
        OP_CONCAT指令是iABC模式
    }
    OP_JMP = {
        OP_JMP A sBx; PC += sBx; if (A) close all upvalues >= R(A - 1)  -- 将PC指针移动sBx个位置，sBx可以是正数也可以是负数，如果A的值为真，所有的upvalues设置为close状态
        OP_JMP指令是iAsBx模式。sBx是一个有符号整数，它的取值范围是-131071～131071
    }
    OP_EQ = {
        OP_EQ A B C; if ((RK(B) == RK(C)) ~= A) then PC++ -- 当A为0时，RK(B)和RK(C)的值相等，PC自增1。当A为1时，RK(B)和RK(C)不相等，PC自增1
        OP_EQ指令是iABC模式
    }
    OP_LT = {
        OP_LT A B C; if ((RK(B) <= RK(C)) ~= A) then PC++ -- 当A为0时，且RK(B) <= RK(C)，PC自增1。当A为1时，且RK(B) >= RK(C)，PC自增1
        OP_LT指令是iABC模式
    }
    OP_TEST = {
        OP_TEST A C; if not (R(A) == C) then PC++ -- 当R(A)的值等于C时，PC自增1
        OP_TEST指令是iABC模式
    }
    OP_TESTSET = {
        OP_TESTSET A B C; if (R(B) == C) then R(A) := R(B) else PC++ -- 当R(B)的值等于C时，将R(B)的值赋值给R(A)，否则PC自增1
        OP_TESTSET指令是iABC模式
    }
    OP_CALL = {
        OP_CALL A B C; R(A), ... ,R(A + C - 2) := R(A)(R(A + 1), ... ,R(A + B - 1)) -- 调用寄存器R(A)上的函数. B是被调用函数的参数个数。当B > 0 时，函数R(A)有B - 1个参数；当B == 0时，从R(A + 1)到栈顶均是函数R(A)的参数；C是函数预期返回的参数个数，当 C > 0 时，函数R(A)的返回值个数为C - 1；当C == 0时，从R(A)到栈顶均是R(A)的返回值。返回值会从R(A)的位置开始覆盖
        OP_CALL指令是iABC模式
    }
    OP_RETURN = {
        OP_RETURN A B; return R(A), ... ,R(A + B - 2) -- A表示第一个返回值位于Lua虚拟栈中的位置，当 B > 0 时，表示从R(A)开始，一共有B - 1个返回值；当 B == 0 时，表示从R(A)开始，一直到栈顶均是返回值
        OP_RETURN指令是iABC模式
    }
    循环语句指令包括OP_FORLOOP、OP_FORPREP、OP_TFORCALL和OP_TFORLOOP，由于这几个指令比较复杂且需要组合使用
    OP_SETLIST = {
        OP_SETLIST A B C; R(A)[(C - 1) * FPF + i] := R(A + i), 1 <= i <= B

        A 指向的位置是Lua表在虚拟栈中的位置
        i 的取值范围是[1, B]
        FPF(Field Per Flush)含义是每次处理的元素个数，Lua默认配置是50
        B 表示一次设置到Lua表中的元素个数，从R(A + 1)开始到R(A + B)的元素，B的值一般不会超过FPF
        C 用来定位表R(A)开始赋值的位置。R(A + 1)到R(A + B)的值，从表的 (C - 1) * FPF + 1 位置开始赋值
        A、B 和 C的值均由编译器决定
        当一个表初始化的元素超过FPF的数量时，编译器会生成多个SETLIST指令

        OP_SETLIST指令是iABC模式
    }
    OP_CLOSURE = {
        OP_CLOSURE A Bx; R(A) := closure(KPROTO[Bx]) -- 创建一个Lua闭包，并将该闭包赋值给寄存器R(A). 新建的Lua闭包关联Proto列表的第Bx个Proto结构
        OP_CLOSURE指令是iABx模式
    }
}