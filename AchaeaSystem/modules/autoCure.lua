local Bus   = ci.Bus
assert(Bus, 'ci.Bus not initialized')
local queue = ci.queue
local curing= ci.curing

local M = { handler = nil }

local function handle(e)
  local affs = e.affs or {}
  local herb = curing.nextHerb(affs)
  if herb then
    queue.push("eat " .. herb, {prio = "high"})
  end
end

---@return boolean always true when module loads
function M.test() return true end

function M.register()
  if M.handler then return end
  M.handler = Bus:on("aff.update", handle)
end

function M.unregister()
  if M.handler then Bus:off(M.handler) M.handler = nil end
end

function M.init()
  M.register()
end

return M
