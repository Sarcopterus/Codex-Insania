local Bus = ci.Bus

local M = { target = nil, handlers = {} }

function M.set(name)
  if not name or name == '' then return end
  if M.target ~= name then
    M.target = name
    if setVariable then setVariable('target', name) end
    Bus:fire('target.changed', name)
  end
end

function M.get()
  return M.target
end

local function handleTell()
  local from = matches[2]
  local who  = matches[3]
  if ci.group and ci.group.callers and ci.group.callers[from] then
    M.set(who)
  end
end

function M.register()
  if M.handlers.tell then return end
  M.handlers.tell = tempRegexTrigger('^(%w+) tells you, "focus (%w+)"', handleTell)
  M.handlers.group = Bus:on('group.focus', function(e) if e.target then M.set(e.target) end end)
end

function M.unregister()
  if M.handlers.tell then killTrigger(M.handlers.tell) end
  if M.handlers.group then Bus:off(M.handlers.group) end
  M.handlers = {}
end

function M.init() M.register() end

return M
