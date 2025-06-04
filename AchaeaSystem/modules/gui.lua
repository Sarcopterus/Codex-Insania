--[[
Optional Geyser GUI elements for displaying system state
]]

local gui = {}

function gui.init()
  if not Geyser then return end
  gui.window = Geyser.Container:new({name = 'AchaeaGUI', x=0, y=0, width='20%', height='100%'})
  gui.health = Geyser.Label:new({name='health', x=0, y=0, width='100%', height=30}, gui.window)
  gui.mana = Geyser.Label:new({name='mana', x=0, y=35, width='100%', height=30}, gui.window)
end

return gui
