local M = {}
local lfs = require('lfs')

function M.generate()
  local outdir = 'docs/api'
  lfs.mkdir(outdir)
  local out = io.open(outdir..'/API.md', 'w')
  if not out then return end
  for file in io.popen("grep -rl '@docs' AchaeaSystem | grep -E '\\.lua$'"):lines() do
    for line in io.lines(file) do
      local doc = line:match('%-%-%- @docs%s*(.*)')
      if doc then out:write(doc .. '\n') end
    end
  end
  out:close()
end

return M
