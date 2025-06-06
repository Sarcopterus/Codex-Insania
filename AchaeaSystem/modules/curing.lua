--[[
Curing module
Handles afflictions and defences using both server-side and client-side logic.
Compatible with Legacy and SVOF conventions.

Usage:
  local curing = require('AchaeaSystem.modules.curing')
  curing.register()
  curing.cure('paresis')
  curing.unregister()

Events:
  - gmcp.Char -> curing.handleChar
  - gmcp.Char.Afflictions -> curing.handleAffs
  - gmcp.Char.Defences -> curing.handleDefences
  - gmcp.IRE.Rift -> curing.handleRift

Shared state:
  curing.afflictions - table of afflictions
  curing.defences - table of defences
]]

local curing = {}
local handlers = {}

curing.afflictions = {}
curing.defences = {}

function curing.handleChar()
  -- fired when gmcp.Char is received
end

function curing.handleAffs()
  local affs = gmcp.Char.Afflictions.List or {}
  curing.afflictions = affs
  -- respond to afflictions here
end

function curing.handleDefences()
  local defs = gmcp.Char.Defences.List or {}
  curing.defences = defs
end

function curing.handleRift()
  -- handle rift updates for herbs and other curing items
end

-- Example call to cure an affliction
function curing.cure(aff)
  -- implement custom curing priorities here
  send("cure " .. aff)
end

function curing.register()
  handlers.char = AchaeaSystem.registerEventHandler("gmcp.Char", "AchaeaSystem.modules.curing.handleChar")
  handlers.affs = AchaeaSystem.registerEventHandler("gmcp.Char.Afflictions", "AchaeaSystem.modules.curing.handleAffs")
  handlers.defs = AchaeaSystem.registerEventHandler("gmcp.Char.Defences", "AchaeaSystem.modules.curing.handleDefences")
  handlers.rift = AchaeaSystem.registerEventHandler("gmcp.IRE.Rift", "AchaeaSystem.modules.curing.handleRift")
end

function curing.unregister()
  for _,h in pairs(handlers) do AchaeaSystem.unregisterEventHandler(h) end
  handlers = {}
end

function curing.init()
  curing.register()
end

return curing