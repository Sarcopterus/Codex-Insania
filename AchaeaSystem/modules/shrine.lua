--[[
Shrine management module
Provides simple helpers to track shrine influence and donate essence.

Usage:
  local shrine = require('AchaeaSystem.modules.shrine')
  shrine.register()
  shrine.donate(100)
  shrine.unregister()

Events:
  - gmcp.Char.Status to update shrine essence
Shared state:
  shrine.essence - current essence in inventory
]]

local shrine = {}
local handlers = {}

shrine.essence = 0

function shrine.handleStatus()
  shrine.essence = tonumber(gmcp.Char.Status.essence or 0)
end

function shrine.donate(amount)
  send(string.format("donate %d essence", amount or shrine.essence))
end

function shrine.register()
  handlers.status = registerAnonymousEventHandler('gmcp.Char.Status', 'AchaeaSystem.modules.shrine.handleStatus')
end

function shrine.unregister()
  if handlers.status then killAnonymousEventHandler(handlers.status) end
  handlers.status = nil
end

return shrine
