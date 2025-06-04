--[[
Curing module
Handles afflictions and defences using both server-side and client-side logic.
Compatible with Legacy and SVOF conventions.
]]

local curing = {}

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

return curing
