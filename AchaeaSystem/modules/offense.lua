local bus   = ci.bus
local queue = ci.queue
local class = require("AchaeaSystem.classes.unnamable")

local M = {}

local function isBusy()
  return queue.isBusy and queue.isBusy() or queue.timer ~= nil or queue.size() > 0
end

local function dispatcher()
  if isBusy() then return end
  local cmd = class.decide()
  if cmd then queue.push(cmd,{prio="normal"}) end
end

bus.subscribe("aff.update", dispatcher)
bus.subscribe("limb.update", dispatcher)

function M.init() end

return M