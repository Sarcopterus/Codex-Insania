local Bus   = ci.Bus
ci.group    = ci.group or { callers = {}, target = nil }

local M = {}
function M.init()
  -- simple trigger: TELLs only (replace with GMCP if desired)
  selectString(line,1); if regexMatch("^%a+ tells you, \"focus (%w+)\"") then
    local who  = matches[2]
    local from = string.match(line,"^(%a+) tells you")
    if ci.group.callers[from] then
      ci.group.target = who
      Bus:fire("group.focus",{target=who})
    end
  end
end
return M
