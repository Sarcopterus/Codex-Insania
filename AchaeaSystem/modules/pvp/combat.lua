--[[
General PvP combat utilities

Usage:
  local combat = require('AchaeaSystem.modules.pvp.combat')
  combat.trackLimb('left arm')
  combat.resetCounters()
Events:
  - none by default; other modules may call trackLimb via triggers

Shared state:
  combat.limbCounter - table counting damage per limb
]]

local combat = {}
local handlers = {}

combat.limbCounter = {}

function combat.resetCounters()
  combat.limbCounter = {}
end

function combat.trackLimb(limb)
  combat.limbCounter[limb] = (combat.limbCounter[limb] or 0) + 1
end

function combat.getLimbCount(limb)
  return combat.limbCounter[limb] or 0
end

function combat.register()
  -- register PvP event handlers here as needed
end

function combat.unregister()
  -- unregister handlers when unloading
  for _, id in pairs(handlers) do AchaeaSystem.unregisterEventHandler(id) end
  handlers = {}
end

function combat.init()
  combat.register()
end

return combat