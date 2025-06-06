--[[
Shrine management module
Provides simple helpers to track shrine influence and donate essence.

Usage:
  local shrine = require('AchaeaSystem.modules.shrine')
  shrine.register()
  shrine.donate(100)
  shrine.unregister()

Events:
  - gmcp.Char.Status to update shrine essence
Shared state:
  shrine.essence - current essence in inventory
]]

local shrine = {}
local handlers = {}
shrine.essence = 0
shrine.corpses = {}
shrine.shrinePresent = false

function shrine.handleStatus()
  shrine.essence = tonumber(gmcp.Char.Status.essence or 0)
end

function shrine.handleItems()
  local list = gmcp.Char.Items.List
  if not list then return end
  if list.location == "room" then
    shrine.shrinePresent = false
    for _, it in ipairs(list.items or {}) do
      if it.name and it.name:lower():find("shrine") then
        shrine.shrinePresent = true
      end
    end
  elseif list.location == "inv" then
    shrine.corpses = {}
    for _, it in ipairs(list.items or {}) do
      if it.name and it.name:lower():find("corpse") then
        table.insert(shrine.corpses, it.id or it.name)
      end
    end
  end
end

function shrine.donate(amount)
  send(string.format("donate %d essence", amount or shrine.essence))
end

function shrine.offerCorpses()
  if shrine.shrinePresent and #shrine.corpses > 0 then
    send("offer corpses to shrine")
    cecho("<green>Offered corpses to shrine\n")
  end
end

function shrine.register()
  handlers.status = AchaeaSystem.on('gmcp.Char.Status', 'AchaeaSystem.modules.shrine.handleStatus')
  handlers.items = AchaeaSystem.on('gmcp.Char.Items.List', 'AchaeaSystem.modules.shrine.handleItems')
end

function shrine.unregister()
  for _,h in pairs(handlers) do AchaeaSystem.off(h) end
  handlers = {}
end

function shrine.init()
  shrine.register()
end

return shrine