
function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function dump_key_value_(v)
    if type(v) == "string" then
        v = v
    end
    if (type(v) == "number") then
        v = "[" .. v .. "]"
    end
    return tostring(v)
end
 
function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == "") then return false end
    local pos, arr = 0, {}
    for st, sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end
 
function trim(input)
    return (string.gsub(input, "^%s*(.-)%s*$", "%1"))
end
 
--[[
打印table的工具函数
@params value 需要打印的内容
@params desciption 描述
@params nesting 打印内容的嵌套级数，默认3级
]]
function dump(value, desciption, nesting, coustem_sort, indent_size)
    if type(nesting) ~= "number" then 
        nesting = 3 
    end
 
    local lookupTable = {}
    local result = {}
    local traceback = split(debug.traceback("", 2), "\n")
    local indent_str = indent_size and string.rep(" ", indent_size) or "\t"
 
    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            -- result[#result +1] = string.format("%s%s%s = %s,", indent, dump_key_value_(desciption), spc, dump_value_(value))
            result[#result +1] = string.format("%s%s%s = %s,", indent, dump_key_value_(desciption), "", dump_value_(value))
        elseif lookupTable[tostring(value)] then
            -- result[#result +1] = string.format("%s%s%s = *REF*,", indent, dump_key_value_(desciption), spc)
            result[#result +1] = string.format("%s%s%s = *REF*,", indent, dump_key_value_(desciption), "")
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*,", indent, dump_key_value_(desciption))
            else
                result[#result + 1] = string.format("%s%s = {", indent, dump_key_value_(desciption))
                local indent2 = indent .. indent_str
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_key_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if coustem_sort then
                        return coustem_sort(a, b)
                    end
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                local end_str = ","
                if nest == 1 then 
                    end_str = "" 
                end
                if next(value) then
                    result[#result +1] = string.format("%s}%s", indent, end_str)
                else
                    result[#result] = result[#result] .. string.format("}%s", end_str)
                end
            end
        end
    end

    dump_(value, desciption, "", 1)
 
    for i, line in ipairs(result) do
        print(line)
    end
end

function ptable(t, name, coustem_sort, indent_size)
    name = name or "table"
    dump(t, name, 10, coustem_sort, indent_size)
end