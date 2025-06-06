--[[
Optional Geyser GUI elements for displaying system state
Easily themed and extendable.

Usage:
  local gui = require('AchaeaSystem.modules.gui')
  gui.init()
  gui.updateVitals(1000, 800)
Events:
  - gmcp.Char.Vitals -> gui.handleVitals
  - shrine.essence via pub/sub -> gui.handleEssence
]]

local gui = {}
local handlers = {}

gui.colors = {
  background = "black",
  text = "white",
}


function gui.handleVitals()
  local vit = gmcp.Char.Vitals or {}
  gui.updateVitals(vit.hp or 0, vit.mp or 0)
end

function gui.handleEssence(amount)
  if gui.essence then
    gui.essence:echo('Essence: ' .. tostring(amount))
  end
end

function gui.register()
  handlers.vitals = AchaeaSystem.registerEventHandler('gmcp.Char.Vitals', 'AchaeaSystem.modules.gui.handleVitals')
  handlers.essence = AchaeaSystem.subscribe('shrine.essence', 'AchaeaSystem.modules.gui.handleEssence')
end

function gui.unregister()
  if handlers.vitals then AchaeaSystem.unregisterEventHandler(handlers.vitals) end
  if handlers.essence then AchaeaSystem.unsubscribe(handlers.essence) end
  handlers.vitals = nil
  handlers.essence = nil
end

function gui.init()
  if not Geyser then return end
  gui.window = Geyser.Container:new({name = 'AchaeaGUI', x=0, y=0, width='20%',height='100%'})
  gui.health = Geyser.Label:new({name='health', x=0, y=0, width='100%', height=30}, gui.window)
  gui.mana = Geyser.Label:new({name='mana', x=0, y=35, width='100%', height=30}, gui.window)
  gui.essence = Geyser.Label:new({name='essence', x=0, y=70, width='100%', height=30}, gui.window)
  gui.health:setStyleSheet('background:' .. gui.colors.background .. ';color:' .. gui.colors.text)
  gui.mana:setStyleSheet('background:' .. gui.colors.background .. ';color:' .. gui.colors.text)
  gui.essence:setStyleSheet('background:' .. gui.colors.background .. ';color:' .. gui.colors.text)
  gui.register()
end

function gui.updateVitals(hp, mp)
  if not gui.health then return end
  gui.health:echo('HP: ' .. hp)
  gui.mana:echo('MP: ' .. mp)
end

return gui
