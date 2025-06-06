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
Shared state:
  unnamable.horror - current stack count
]]

local unnamable = {}
local handlers = {}
]]

local unnamable = {}

unnamable.horror = 0

function unnamable.addHorror()
  unnamable.horror = unnamable.horror + 1
  raiseEvent('unnamable.horror', unnamable.horror)
end

function unnamable.handleHorrorEvent()
  unnamable.addHorror()
end

function unnamable.resetHorror()
  unnamable.horror = 0
end

function unnamable.extinction(target)
  send("extinction " .. (target or ""))
end

function unnamable.catastrophe(target)
  send("catastrophe " .. (target or ""))
end

function unnamable.register()
  handlers.horror = registerAnonymousEventHandler('unnamable.horror_gain', 'AchaeaSystem.modules.pvp.unnamable.handleHorrorEvent')
end

function unnamable.unregister()
  if handlers.horror then killAnonymousEventHandler(handlers.horror) end
  handlers.horror = nil
end
return unnamable
