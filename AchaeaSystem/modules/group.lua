--[[
Group module - utilities for group combat and forays

Usage:
  local grp = require('AchaeaSystem.modules.group')
  grp.follow('Leader')
  grp.stop()

Events:
  (none by default; integrate with your own triggers if needed)
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
  -- register group-related event handlers here if desired
end

function group.unregister()
  for _, id in pairs(handlers) do AchaeaSystem.unregisterEventHandler(id) end
  handlers = {}
end

function group.init()
  group.register()
end

function group.stop()
  group.leader = nil
  send("unfollow")
end

return group