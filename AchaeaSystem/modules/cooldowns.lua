local Bus = ci.Bus
assert(Bus, 'ci.Bus not initialized')

local M = { timers = {}, handlers = {} }

local function now()
  if getStopWatchTime then return getStopWatchTime() else return os.time() end
end

function M.start(skill, seconds)
  skill = skill:lower()
  seconds = tonumber(seconds)
  if not seconds then return end
  if M.timers[skill] and M.timers[skill].timer then killTimer(M.timers[skill].timer) end
  local expire = now() + seconds
  local id = tempTimer(seconds, function()
    M.timers[skill] = nil
    if Bus then Bus:fire('cooldown.expired', skill) end
  end)
  M.timers[skill] = {expire=expire, timer=id}
  if Bus then Bus:fire('cooldown.gained', skill, seconds) end
end

function M.remaining(skill)
  skill = skill:lower()
  local c = M.timers[skill]
  if not c then return 0 end
  return math.max(0, c.expire - now())
end

function M.handleGmcp()
  local data = gmcp.Char and (gmcp.Char.Cooldowns or (gmcp.Char.Skills and gmcp.Char.Skills.Cooldowns))
  if type(data) == 'table' then
    for k,v in pairs(data) do
      M.start(k, tonumber(v))
    end
  end
end

function M.handleText()
  local secs = tonumber(matches[2])
  local skill = matches[3]
  if secs and skill then M.start(skill, secs) end
end

function M.register()
  if M.handlers.gmcp then return end
  M.handlers.gmcp1 = AchaeaSystem.on('gmcp.Char.Cooldowns', 'AchaeaSystem.modules.cooldowns.handleGmcp')
  M.handlers.gmcp2 = AchaeaSystem.on('gmcp.Char.Skills.Cooldowns', 'AchaeaSystem.modules.cooldowns.handleGmcp')
  M.handlers.msg = tempRegexTrigger('^You must wait ([0-9]+) more seconds? to use ([%w%s]+)%.$', 'AchaeaSystem.modules.cooldowns.handleText')
end

function M.unregister()
  if M.handlers.gmcp1 then AchaeaSystem.off(M.handlers.gmcp1) end
  if M.handlers.gmcp2 then AchaeaSystem.off(M.handlers.gmcp2) end
  if M.handlers.msg then killTrigger(M.handlers.msg) end
  M.handlers = {}
  for _,v in pairs(M.timers) do if v.timer then killTimer(v.timer) end end
  M.timers = {}
end

function M.init()
  M.register()
end

return M
