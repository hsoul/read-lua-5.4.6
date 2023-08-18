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
            [1] = "iABC:OP_GETTABUP      A:0   B  :0   C:256 ; R(A) := UpValue[B][RK(C)]",
            [2] = "iABx:OP_LOADK         A:1   Bx :1         ; R(A) := Kst(Bx)",
            [3] = "iABC:OP_CALL          A:0   B  :2   C:1   ; R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1))",
            [4] = "iABC:OP_RETURN        A:0   B  :1         ; return R(A), ... ,R(A+B-2)  (see note)",
        },
        is_vararg = 1,
        k = {
            [1] = "print",
            [2] = "float:4621256167635550208",
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
