local files = {}
for f in io.popen("find AchaeaSystem -name '*.lua'"):lines() do table.insert(files,f) end
local ok = true
for _,f in ipairs(files) do
  local res, typ, status = os.execute(string.format('luac -p %s', f))
  if not res then ok=false print('syntax error in '..f) end
end
if ok then print('syntax OK') else print('syntax check failed') end
