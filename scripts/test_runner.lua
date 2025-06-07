local files = {}
for f in io.popen("find AchaeaSystem -name '*.lua'"):lines() do table.insert(files,f) end
local ok = true
for _,f in ipairs(files) do
  local res, typ, status = os.execute(string.format('luac -p %s', f))
  if not res then ok=false print('syntax error in '..f) end
end
if not ok then print('syntax check failed') os.exit(1) else print('syntax OK') end

package.path = 'AchaeaSystem/?.lua;AchaeaSystem/?/init.lua;' .. package.path
ci = {Bus={on=function()end,fire=function()end}, queue={push=function()end}}

dofile('AchaeaSystem/core/cureTables.lua')
local ac = require('AchaeaSystem.modules.autoCure')
assert(ac.test())
print('tests passed')
