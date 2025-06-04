--[[
General PvP combat utilities
]]

local combat = {}

combat.limbCounter = {}

function combat.resetCounters()
  combat.limbCounter = {}
end

function combat.trackLimb(limb)
  combat.limbCounter[limb] = (combat.limbCounter[limb] or 0) + 1
end

return combat
