--[[
Event Bus module
Provides simple publish/subscribe helpers for other modules.
]]

local bus = {}
local counter = 0
local handlers = {}

-- publish an event to any subscribers
function bus.publish(name, ...)
  raiseEvent("AchaeaSystem." .. name, ...)
end

function bus.fire(name, ...)
  bus.publish(name, ...)
end

-- subscribe to an event, returns handler id
function bus.subscribe(name, func)
  local id = registerAnonymousEventHandler("AchaeaSystem." .. name, func)
  handlers[id] = true
  return id
end

bus.on = bus.subscribe

-- remove a subscription
function bus.unsubscribe(id)
  if id then
    killAnonymousEventHandler(id)
    handlers[id] = nil
  end
end

bus.off = bus.unsubscribe

return bus
