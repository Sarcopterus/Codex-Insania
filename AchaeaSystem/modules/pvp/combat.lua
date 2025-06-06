--[[
General PvP combat utilities

Usage:
  local combat = require('AchaeaSystem.modules.pvp.combat')
  combat.trackLimb('left arm')
  combat.resetCounters()

Shared state:
  combat.limbCounter - table counting damage per limb
]]

local combat = {}

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

return combat
