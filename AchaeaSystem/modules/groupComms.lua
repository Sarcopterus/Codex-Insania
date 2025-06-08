local Bus   = ci.Bus
assert(Bus, 'ci.Bus not initialized')
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

function M.register()
  if M.trig then return end
  M.trig = tempRegexTrigger("^(%w+) tells you, \"focus (%w+)\"$", onTell)
end

function M.unregister()
  if M.trig then killTrigger(M.trig) M.trig = nil end
end

function M.init()
  M.register()
end

return M
