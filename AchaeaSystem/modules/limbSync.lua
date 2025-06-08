--[[
Legacy limb tracker bridge
Listens for limb counter updates and republishes them via "limb.update".
Adjust the source event name if your limb tracker uses a different one.
]]

local limbSync = {}
local handlers = {}
local Bus = ci.Bus
assert(Bus, 'ci.Bus not initialized')

function limbSync.handleUpdate(...)
  Bus:fire('limb.update', ...)
end

function limbSync.register()
  handlers.update = AchaeaSystem.registerEventHandler('limbCounterUpdated', 'AchaeaSystem.modules.limbSync.handleUpdate')
end

function limbSync.unregister()
  if handlers.update then AchaeaSystem.unregisterEventHandler(handlers.update) end
  handlers.update = nil
end

function limbSync.init()
  limbSync.register()
end

return limbSync
