local Bus   = ci.Bus
ci.group    = ci.group or { callers = {}, target = nil }

local M = { trig = nil }

local function onTell()
  local from = matches[2]
  local who  = matches[3]
  if ci.group.callers[from] then
    ci.group.target = who
    Bus:fire("group.focus", {target = who})
  end
end

function M.init()
  if M.trig then return end
  M.trig = tempRegexTrigger("^(%w+) tells you, \"focus (%w+)\"$", onTell)
end

return M