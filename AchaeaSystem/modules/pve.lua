--[[
PvE module - automated bashing routines
Includes basic crowdmap integration and battlerage usage.
]]

local pve = {}

pve.target = nil

function pve.start(target)
  pve.target = target or ""
  send("queue add eqbal bash " .. pve.target)
end

function pve.stop()
  pve.target = nil
  send("queue clear eqbal")
end

-- simple battlerage usage
function pve.useBattlerage()
  send("battlerage repeat on")
end

return pve
