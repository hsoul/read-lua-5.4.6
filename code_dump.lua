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
            [1] = "iABx:OP_LOADK         A:0   Bx :0         ; R(A) := Kst(Bx)",
            [2] = "iABx:OP_LOADK         A:1   Bx :1         ; R(A) := Kst(Bx)",
            [3] = "iABx:OP_CLOSURE       A:2   Bx :0         ; R(A) := closure(KPROTO[Bx])",
            [4] = "iABC:OP_SETTABUP      A:0   B  :258 C:2   ; UpValue[A][RK(B)] := RK(C)",
            [5] = "iABC:OP_GETTABUP      A:2   B  :0   C:259 ; R(A) := UpValue[B][RK(C)]",
            [6] = "iABC:OP_ADD           A:3   B  :0   C:1   ; R(A) := RK(B) + RK(C)",
            [7] = "iABC:OP_CALL          A:2   B  :2   C:1   ; R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1))",
            [8] = "iABC:OP_RETURN        A:0   B  :1         ; return R(A), ... ,R(A+B-2)  (see note)",
        },
        is_vararg = 1,
        k = {
            [1] = "int:1",
            [2] = "int:2",
            [3] = "foo",
            [4] = "print",
        },
        lastlinedefine = 0,
        linedefine = 0,
        locvars = {
            [1] = {
                endpc = 8,
                startpc = 1,
                varname = "a",
            },
            [2] = {
                endpc = 8,
                startpc = 2,
                varname = "b",
            },
        },
        maxstacksize = 4,
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
        p = {
            [1] = {
                code = {
                    [1] = "iABC:OP_GETUPVAL      A:0   B  :0         ; R(A) := UpValue[B]",
                    [2] = "iABC:OP_GETTABUP      A:1   B  :1   C:256 ; R(A) := UpValue[B][RK(C)]",
                    [3] = "iABC:OP_MOVE          A:2   B  :0         ; R(A) := R(B)",
                    [4] = "iABC:OP_CALL          A:1   B  :2   C:1   ; R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1))",
                    [5] = "iABC:OP_GETTABUP      A:1   B  :1   C:256 ; R(A) := UpValue[B][RK(C)]",
                    [6] = "iABC:OP_GETTABUP      A:2   B  :1   C:257 ; R(A) := UpValue[B][RK(C)]",
                    [7] = "iABC:OP_CALL          A:1   B  :2   C:1   ; R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1))",
                    [8] = "iABC:OP_RETURN        A:0   B  :1         ; return R(A), ... ,R(A+B-2)  (see note)",
                },
                is_vararg = 0,
                k = {
                    [1] = "print",
                    [2] = "d",
                },
                lastlinedefine = 8,
                linedefine = 4,
                locvars = {
                    [1] = {
                        endpc = 8,
                        startpc = 1,
                        varname = "c",
                    },
                },
                maxstacksize = 3,
                numparams = 0,
                type_name = "Proto",
                upvalues = {
                    [1] = {
                        idx = 1,
                        instack = 1,
                        name = "b",
                    },
                    [2] = {
                        idx = 0,
                        instack = 0,
                        name = "_ENV",
                    },
                },
            },
        },
    },
}
