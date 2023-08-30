file_name = "ltest/pp.lua.out"
closure = {
    type_name = "LClosure",
    upvals = {
        [1] = {
            name = "_ENV",
        },
    },
    proto = {
        code = {
            [1] = "iABC:OP_SETTABUP      A:0   B  :256 C:257 ; UpValue[A][RK(B)] := RK(C)",
            [2] = "iABC:OP_SETTABUP      A:0   B  :258 C:259 ; UpValue[A][RK(B)] := RK(C)",
            [3] = "iABC:OP_SETTABUP      A:0   B  :260 C:261 ; UpValue[A][RK(B)] := RK(C)",
            [4] = "iABC:OP_SETTABUP      A:0   B  :262 C:263 ; UpValue[A][RK(B)] := RK(C)",
            [5] = "iABC:OP_SETTABUP      A:0   B  :264 C:265 ; UpValue[A][RK(B)] := RK(C)",
            [6] = "iABC:OP_RETURN        A:0   B  :1         ; return R(A), ... ,R(A+B-2)  (see note)",
        },
        is_vararg = 1,
        k = {
            [1] = "ga",
            [2] = "int:1",
            [3] = "gb",
            [4] = "nil",
            [5] = "gc",
            [6] = "float:4623170197477182669",
            [7] = "gd",
            [8] = "boolean:1",
            [9] = "gf",
            [10] = "hello world",
        },
        lastlinedefine = 0,
        linedefine = 0,
        locvars = {},
        maxstacksize = 2,
        numparams = 0,
        source = "@ltest/pp.lua",
        type_name = "Proto",
        upvalues = {
            [1] = {
                idx = 0,
                instack = 1,
                name = "_ENV",
            },
        },
    },
}
