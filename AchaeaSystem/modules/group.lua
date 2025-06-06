--[[
Group module - utilities for group combat and forays

Usage:
  local grp = require('AchaeaSystem.modules.group')
  grp.follow('Leader')
  grp.stop()

Events:
  - custom "group.disband" to trigger group.stop
Shared state:
  group.leader - current leader being followed
]]

local group = {}
local handlers = {}

group.leader = nil

function group.follow(name)
  group.leader = name
  send("follow " .. name)
end

function group.register()
  handlers.disband = AchaeaSystem.registerEventHandler('group.disband', 'AchaeaSystem.modules.group.stop')
end

function group.unregister()
  if handlers.disband then AchaeaSystem.unregisterEventHandler(handlers.disband) end
  handlers.disband = nil
end

function group.init()
  group.register()
end

function group.stop()
  group.leader = nil
  send("unfollow")
end

return group