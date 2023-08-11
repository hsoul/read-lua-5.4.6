-- print("hello")
local print = print
print(_ENV, _G)
local ENV = _ENV
local _ENV = {
  x = 17565,
  debug = ENV.debug
}

print(_ENV)

function xx()
  -- print(a)
  -- print(x)
  -- print(_G)
  print(x)
  -- print(a)
  -- print(debug.getupvalue(xx, 3))
end

xx()