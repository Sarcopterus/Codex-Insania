--[[
Curing module
Integrates server-side curing with client helpers.
Provides toggling via alias `ssc on|off` and allows class-based priority overrides.
@docs Use curing.enable(), curing.disable(), curing.setClass(class).
]]

local curing = {
  afflictions = {},
  defences    = {},
  enabled     = false,
  enemyClass  = 'unknown',
  handlers    = {},
  classOverrides = {}
}
local queue = AchaeaSystem.queue
local Bus   = ci.bus

-- default class priority overrides
curing.classOverrides.serpent = { hypochondria=1, impatience=1 }

local function sendCmd(cmd)
  queue.push(cmd)
end

function curing.enable()
  sendCmd('CURING ON')
  curing.enabled = true
  Bus:fire('curing.status', true)
end

function curing.disable()
  sendCmd('CURING OFF')
  curing.enabled = false
  Bus:fire('curing.status', false)
end

function curing.toggle(on)
  if on == 'on' then curing.enable() else curing.disable() end
end

function curing.queryStatus()
  sendCmd('CURING STATUS')
end

function curing.insertPriority(aff, prio)
  prio = prio or 1
  sendCmd(string.format('CURING PRIORITY INSERT %s %d', aff, prio))
end

function curing.prioaff(aff)
  if aff then sendCmd('CURING PRIOAFF ' .. aff) end
end

function curing.queueAdd(aff)
  if aff then sendCmd('CURING QUEUE ADD ' .. aff) end
end

function curing.queueRemove(aff)
  if aff then sendCmd('CURING QUEUE REMOVE ' .. aff) end
end

function curing.setClass(cls)
  curing.enemyClass = cls
  local o = curing.classOverrides[cls]
  if o then
    for aff,prio in pairs(o) do curing.insertPriority(aff, prio) end
  end
end

function curing.handleAffs()
  curing.afflictions = gmcp.Char.Afflictions.List or {}
  Bus:fire('aff.update', {affs=curing.afflictions})
end

function curing.handleStatus(line)
  local state = line:match('Server%-side curing:?%s*(%w+)')
  if state then
    curing.enabled = state:lower() == 'on'
    Bus:fire('curing.status', curing.enabled)
  end
end

function curing.handlePrediction(line)
  if AchaeaSystem.modules and AchaeaSystem.modules.afftracker then
    AchaeaSystem.modules.afftracker.handlePred(line)
  end
end

function curing.handleDefences()
  curing.defences = gmcp.Char.Defences.List or {}
end

function curing.register()
  curing.handlers.affs = AchaeaSystem.on('gmcp.Char.Afflictions', 'AchaeaSystem.modules.curing.handleAffs')
  curing.handlers.defs = AchaeaSystem.on('gmcp.Char.Defences', 'AchaeaSystem.modules.curing.handleDefences')
  curing.handlers.status = tempRegexTrigger('^Server%-side curing', 'AchaeaSystem.modules.curing.handleStatus')
  curing.handlers.pred   = tempRegexTrigger('^Curing predictions', 'AchaeaSystem.modules.curing.handlePrediction')
end

function curing.unregister()
  for key,id in pairs(curing.handlers) do
    if key == 'status' or key == 'pred' then killTrigger(id) else AchaeaSystem.off(id) end
  end
  curing.handlers = {}
end

function curing.init()
  curing.register()
end

return curing
