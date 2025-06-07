--[[
Affliction Tracker bridge
Listens for the AfflictionTracker event "affsUpdated" and republishes
an "aff.update" event for other modules.
]]

local affSync = {}
local handlers = {}
local Bus = ci.bus

function affSync.handleUpdate(...)
  Bus:fire('aff.update', ...)
end

function affSync.register()
  handlers.affs = AchaeaSystem.registerEventHandler('affsUpdated', 'AchaeaSystem.modules.affSync.handleUpdate')
end

function affSync.unregister()
  if handlers.affs then AchaeaSystem.unregisterEventHandler(handlers.affs) end
  handlers.affs = nil
end

function affSync.init()
  affSync.register()
end

return affSync