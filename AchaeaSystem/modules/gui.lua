--[[
Optional Geyser GUI elements for displaying system state

Easily themed and extendable.

Usage:
  local gui = require('AchaeaSystem.modules.gui')
  gui.init()
  gui.updateVitals(1000, 800)

]]

local gui = {}
gui.colors = {
  background = "black",
  text = "white",
}

function gui.init()
  if not Geyser then return end
  gui.window = Geyser.Container:new({name = 'AchaeaGUI', x=0, y=0, width='20%', height='100%'})
  gui.health = Geyser.Label:new({name='health', x=0, y=0, width='100%', height=30}, gui.window)
  gui.mana = Geyser.Label:new({name='mana', x=0, y=35, width='100%', height=30}, gui.window)
  gui.health:setStyleSheet('background:' .. gui.colors.background .. ';color:' .. gui.colors.text)
  gui.mana:setStyleSheet('background:' .. gui.colors.background .. ';color:' .. gui.colors.text)
end

function gui.updateVitals(hp, mp)
  if not gui.health then return end
  gui.health:echo('HP: ' .. hp)
  gui.mana:echo('MP: ' .. mp)
end

return gui
