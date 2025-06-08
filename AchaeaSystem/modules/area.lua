local area = {history = {}, handlers = {}}

function area.record()
  local areaName = gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.area
  if not areaName then return end
  if area.history[1] ~= areaName then
    table.insert(area.history, 1, areaName)
    if #area.history > 5 then table.remove(area.history) end
  end
end

function area.printHistory()
  for i,name in ipairs(area.history) do
    cecho(string.format("%d: %s\n", i, name))
  end
end

function area.register()
  if area.handlers.info then return end
  area.handlers.info = AchaeaSystem.registerEventHandler('gmcp.Room.Info','AchaeaSystem.modules.area.record')
end

function area.unregister()
  if area.handlers.info then AchaeaSystem.unregisterEventHandler(area.handlers.info) end
  area.handlers = {}
end

function area.init()
  area.register()
end

return area
