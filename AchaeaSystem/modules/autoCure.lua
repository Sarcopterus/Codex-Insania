local bus       = ci.bus
local queue     = ci.queue
local curing    = ci.curing

local M = {}
local function isBusy()
  if queue.isBusy then return queue.isBusy() end
  return queue.timer ~= nil or queue.size() > 0
end

local function handle(affs)
  if isBusy() then return end
  local cmd
  local salve = curing.nextCure(affs, "salve")
  if salve then cmd = "apply " .. salve
  else
    local herb = curing.nextCure(affs, "herb")
    if herb then cmd = "eat " .. herb
    elseif curing.nextCure(affs, "focus") then cmd = "focus" end
  end
  if cmd then queue.push(cmd,{prio="high"}) end
end

bus.subscribe("aff.update", handle)

function M.init() end
return M
