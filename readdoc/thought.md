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