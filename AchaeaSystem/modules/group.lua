--[[
Group module - utilities for group combat and forays

Usage:
  local grp = require('AchaeaSystem.modules.group')
  grp.follow('Leader')
  grp.stop()

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
  handlers.disband = registerAnonymousEventHandler('group.disband', 'AchaeaSystem.modules.group.stop')
end

function group.unregister()
  if handlers.disband then killAnonymousEventHandler(handlers.disband) end
  handlers.disband = nil
end

function group.stop()
  group.leader = nil
  send("unfollow")
end

return group
