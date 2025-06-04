--[[
Group module - utilities for group combat and forays
]]

local group = {}

group.leader = nil

function group.follow(name)
  group.leader = name
  send("follow " .. name)
end

function group.stop()
  group.leader = nil
  send("unfollow")
end

return group
