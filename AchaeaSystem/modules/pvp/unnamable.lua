--[[
Unnamable SnB specific combat logic
Handles horror stacks and finisher skills.

Usage:
  local u = require('AchaeaSystem.modules.pvp.unnamable')
  u.register()
  u.addHorror()
  u.extinction('enemy')
  u.unregister()

Events:
  - custom "horror gained" event for stack tracking
  - publishes "horror_gain" when stacks increase
Shared state:
  unnamable.horror - current stack count
]]

local unnamable = {}
local handlers = {}

unnamable.horror = 0

function unnamable.addHorror()
  unnamable.horror = unnamable.horror + 1
  AchaeaSystem.publish('horror_gain', unnamable.horror)
end

function unnamable.handleHorrorEvent()
  unnamable.addHorror()
end

function unnamable.resetHorror()
  unnamable.horror = 0
end

function unnamable.extinction(target)
  AchaeaSystem.queue.push("extinction " .. (target or ""))
end

function unnamable.catastrophe(target)
  AchaeaSystem.queue.push("catastrophe " .. (target or ""))
end

function unnamable.register()
  handlers.horror = AchaeaSystem.subscribe('horror_gain', 'AchaeaSystem.modules.pvp.unnamable.handleHorrorEvent')
end

function unnamable.unregister()
  if handlers.horror then AchaeaSystem.unsubscribe(handlers.horror) end
  handlers.horror = nil
end

function unnamable.init()
  unnamable.register()
end

return unnamable