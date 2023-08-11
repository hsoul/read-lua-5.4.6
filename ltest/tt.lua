local var1 = 1
local function aaa()
    local var2 = 1
    return function()
        var1 = var1 + 1
        var2 = var2 + 1

        print(var1, var2)
    end,
    function()
        var1 = var1 + 1
        var2 = var2 + 1

        print(var1, var2)
    end
end

local f1, f2 = aaa()
local f3 = aaa()

f1()
f2()
f3()

-- 2       2
-- 3       2

local var1 = 1
function aaa()
    local var2 = 1
    function bbb()
        var1 = var1 + 1
        var2 = var2 + 1
        print("bbb:", var1, var2)
    end 

    function ccc()
        var1 = var1 + 1
        var2 = var2 + 1
        print("ccc:", var1, var2)
    end

    bbb()
    print("hahaha")
end

aaa()

bbb()
bbb()

ccc()
ccc()

-- bbb:    2       2
-- hahaha
-- bbb:    3       3
-- bbb:    4       4
-- ccc:    5       5
-- ccc:    6       6

-- local a = 1
-- local b = 2

-- function xxx()
--     local c = 3
--     print(a)
--     function yyy()
--         print(a + b + c)
--     end
-- end


-- local a = 1
-- local b = 2

-- function xxx()
--     local c = 3
--     -- a = a + 1
--     print(a)
--     function yyy()
--         -- print(a + b + c)
--         a = b 
--         b = c
--     end
-- end