--[[
Affliction tracker synchronisation.
Keeps local affliction table up to date with server predictions.
@docs Provides afftracker.update(list) and predictions table.
]]

local M = { affs = {}, predictions = {}, handlers = {} }

local Bus = ci.Bus
assert(Bus, 'ci.Bus not initialized')

function M.update(list)
  M.affs = list or {}
end

function M.handlePred(line)
  -- Expect: "Curing predictions: aff1, aff2" etc.
  local affs = {}
  for aff in line:gmatch('%w+') do table.insert(affs, aff) end
  M.predictions = affs
  if Bus then Bus:fire('curing.predictions', affs) end
end

function M.register()
  if M.handlers.aff then return end
  M.handlers.aff = Bus:on('aff.update', function(e) M.update(e.affs or e) end)
  M.handlers.pred = tempRegexTrigger('^Curing predictions:? (.*)$',
    'AchaeaSystem.modules.afftracker.handlePred')
end

function M.unregister()
  if M.handlers.aff then Bus:off(M.handlers.aff) end
  if M.handlers.pred then killTrigger(M.handlers.pred) end
  M.handlers = {}
end

function M.init()
  M.register()
end

return M
