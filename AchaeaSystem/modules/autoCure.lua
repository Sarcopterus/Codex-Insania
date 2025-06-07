local Bus       = ci.Bus
local queue     = ci.queue
local curing    = ci.curing

local M = {}
function M.init()
  Bus:on("aff.update", function(e)
    local affs = e.affs
    local cmd
    if curing.shouldFocus(affs)            then cmd = "focus"
    elseif curing.nextSalve(affs)          then cmd = "apply "..curing.nextSalve(affs)
    elseif curing.nextHerb(affs)           then cmd = "eat "..curing.nextHerb(affs)
    end
    if cmd then queue.push(cmd,{prio="high"}) end
  end)
end
return M
