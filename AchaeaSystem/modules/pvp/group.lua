--- @docs Group assist module keeping roster and focus
local group = {roster={}, target=nil}
local handlers = {}

function group.handlePlayers()
  group.roster = gmcp.Room and gmcp.Room.Players or {}
end

function group.setTarget(t)
  if t and group.target ~= t then
    group.target = t
    AchaeaSystem.publish('ci.events.groupFocus', t)
    AchaeaSystem.queue.push('assist '..t)
  end
end

function group.register()
  handlers.room = registerAnonymousEventHandler('gmcp.Room.Players', 'AchaeaSystem.modules.pvp.group.handlePlayers')
end

function group.unregister()
  if handlers.room then killAnonymousEventHandler(handlers.room) end
  handlers.room = nil
end

function group.init()
  group.register()
end

return group
