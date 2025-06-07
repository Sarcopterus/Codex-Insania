local Bus   = ci.Bus
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

function M.init()
  if M.handler then return end
  M.handler = Bus:on("aff.update", handle)
end

return M