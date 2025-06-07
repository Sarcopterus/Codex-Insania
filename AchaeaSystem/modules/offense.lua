local affs   = ci.affs          -- bridge to afflictiontracker.lua
local limbs  = ci.limbs
local queue  = ci.queue

local SOFT   = { asthma=true, impatience=true, slickness=true, anorexia=true }

local M = {}
-----------------------------------------------------------------------------
local function softLocked(a)
  for k in pairs(SOFT) do if not a[k] then return false end end
  return true
end
-----------------------------------------------------------------------------
local function pickPrepLimb(snap)
  local worst, hp = nil, 101
  for limb,data in pairs(snap) do
    local cur = data.hp or 100
    if data.broken then return limb end         -- already broken? keep pounding
    if cur < hp then hp, worst = cur, limb end
  end
  return worst
end
-----------------------------------------------------------------------------
function M.decide()
  local a   = affs.snapshot()
  local s   = limbs.snapshot()
  if not s then return end

  if softLocked(a) and (s.torso and s.torso.broken) then
    queue.push("execute horrorstrike",{prio="high"})
    return
  end

  local limb = pickPrepLimb(s)
  if limb then queue.push("prep "..limb,{prio="normal"}) end
end
-----------------------------------------------------------------------------
function M.init()
  ci.Bus:on("aff.update",   M.decide)
  ci.Bus:on("limb.update",  M.decide)
end
return M
