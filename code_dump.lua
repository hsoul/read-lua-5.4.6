file_name = "ltest/tt.lua.out"
closure = {
    type_name = "LClosure",
    upvals = {
        [1] = {
            name = "_ENV",
        },
    },
    proto = {
        is_vararg = 1,
        k = {
            [1] = "int:1",
            [2] = "int:2",
            [3] = "xxx",
        },
        locvars = {
            [1] = {
                endpc = 5,
                startpc = 1,
                varname = "a",
            },
            [2] = {
                endpc = 5,
                startpc = 2,
                varname = "b",
            },
        },
        maxstacksize = 3,
        numparams = 0,
        source = "@ltest/tt.lua",
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
                is_vararg = 0,
                k = {
                    [1] = "int:3",
                    [2] = "print",
                    [3] = "yyy",
                },
                locvars = {
                    [1] = {
                        endpc = 7,
                        startpc = 1,
                        varname = "c",
                    },
                },
                maxstacksize = 3,
                numparams = 0,
                type_name = "Proto",
                upvalues = {
                    [1] = {
                        idx = 0,
                        instack = 0,
                        name = "_ENV",
                    },
                    [2] = {
                        idx = 0,
                        instack = 1,
                        name = "a",
                    },
                    [3] = {
                        idx = 1,
                        instack = 1,
                        name = "b",
                    },
                },
                p = {
                    [1] = {
                        is_vararg = 0,
                        k = {
                            [1] = "print",
                        },
                        locvars = {},
                        maxstacksize = 3,
                        numparams = 0,
                        type_name = "Proto",
                        upvalues = {
                            [1] = {
                                idx = 0,
                                instack = 0,
                                name = "_ENV",
                            },
                            [2] = {
                                idx = 1,
                                instack = 0,
                                name = "a",
                            },
                            [3] = {
                                idx = 2,
                                instack = 0,
                                name = "b",
                            },
                            [4] = {
                                idx = 0,
                                instack = 1,
                                name = "c",
                            },
                        },
                    },
                },
            },
        },
    },
}
