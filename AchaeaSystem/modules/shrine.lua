--[[
Shrine management module
Tracks shrine presence and corpse inventory, offering helpers to donate essence automatically.

Usage:
  local shrine = require('AchaeaSystem.modules.shrine')
  shrine.register()
  shrine.donate(100)
  shrine.unregister()

Events:
  - gmcp.Char.Status -> shrine.essence update
  - gmcp.Char.Items.List -> shrine.presence and shrine.corpses updates
  - publishes "shrine.offered" when corpses are donated
Shared state:
  shrine.essence - current essence in inventory
]]

local shrine = {}
local handlers = {}
shrine.essence = 0
shrine.corpses = {}
shrine.shrinePresent = false
shrine.auto = false

local function checkAuto()
  if not shrine.auto then return end
  local vit = gmcp.Char and gmcp.Char.Vitals or {}
  if vit.in_combat then return end
  shrine.offerCorpses()
end

function shrine.handleStatus()
  shrine.essence = tonumber(gmcp.Char.Status.essence or 0)
  AchaeaSystem.publish('shrine.essence', shrine.essence)
end

function shrine.handleItems()
  local list = gmcp.Char.Items.List
  if not list then return end
  if list.location == "room" then
    local present = false
    for _, it in ipairs(list.items or {}) do
      if it.name and it.name:lower():find("shrine") then
        present = true
      end
    end
    if shrine.shrinePresent ~= present then
      shrine.shrinePresent = present
      AchaeaSystem.publish('shrine.presence', shrine.shrinePresent)
    end
    checkAuto()
  elseif list.location == "inv" then
    shrine.corpses = {}
    for _, it in ipairs(list.items or {}) do
      if it.name and it.name:lower():find("corpse") then
        table.insert(shrine.corpses, it.id or it.name)
      end
    end
    AchaeaSystem.publish('shrine.corpses', shrine.corpses)
    checkAuto()
  end
end

function shrine.donate(amount)
  AchaeaSystem.queue.push(string.format("donate %d essence", amount or shrine.essence))
end

function shrine.offerCorpses()
  if shrine.shrinePresent and #shrine.corpses > 0 then
    AchaeaSystem.queue.push("offer corpses to shrine")
    cecho("<green>Offered corpses to shrine\n")
    AchaeaSystem.publish('shrine.offered')
  end
end

function shrine.toggleAuto(arg)
  shrine.auto = (arg == 'on')
  cecho(string.format('<cyan>Shrine auto %s\n', shrine.auto and 'enabled' or 'disabled'))
  checkAuto()
end

function shrine.register()
  handlers.status = AchaeaSystem.registerEventHandler('gmcp.Char.Status', 'AchaeaSystem.modules.shrine.handleStatus')
  handlers.items = AchaeaSystem.registerEventHandler('gmcp.Char.Items.List', 'AchaeaSystem.modules.shrine.handleItems')
  handlers.room  = AchaeaSystem.registerEventHandler('gmcp.Room.Info', 'AchaeaSystem.modules.shrine.handleItems')
end

function shrine.unregister()
  for _,h in pairs(handlers) do AchaeaSystem.unregisterEventHandler(h) end
  handlers = {}
end

function shrine.init()
  shrine.register()
end

return shrine
