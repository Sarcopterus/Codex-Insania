--[[
PvE module - automated bashing routines
Includes basic crowdmap integration and battlerage usage.
Compatible with Mudlet crowdmap package.

Usage:
  local pve = require('AchaeaSystem.modules.pve')
  pve.start('goblin')
  pve.gotoArea('Delos')
  pve.stop()

Shared state:
  pve.target - current NPC target
]]

local pve = {}
local handlers = {}

pve.target = nil

function pve.start(target)
  pve.target = target or ""
  send("queue add eqbal bash " .. pve.target)
end

function pve.stop()
  pve.target = nil
  send("queue clear eqbal")
end

function pve.gotoArea(area)
  send("crowdmap goto " .. area)
end

-- simple battlerage usage
function pve.useBattlerage()
  send("battlerage repeat on")
end

function pve.register()
  handlers.death = registerAnonymousEventHandler('gmcp.Char.Vitals', 'AchaeaSystem.modules.pve.stop')
end

function pve.unregister()
  if handlers.death then killAnonymousEventHandler(handlers.death) end
  handlers.death = nil
end

return pve
