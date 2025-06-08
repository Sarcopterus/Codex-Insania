--[[
Unnamable SnB combat automation.
This module handles limb preparation and Extinction/Catastrophe logic while
tracking horror stacks.  It subscribes to affliction and limb update events via
`ci.Bus` and queues actions through `ci.queue`.

Public API:
  M.register()     -- register event handlers
  M.unregister()   -- remove handlers
  M.init()         -- convenience; calls register()
  M.decide(state)  -- run decision logic using optional state overrides
  M.addHorror() / removeHorror() / resetHorror()
  M.isLimbBroken(limb) / isLimbMangled(limb)
  M.countMangledLimbs() / validExtinctionTarget()
]]

local Offense = require('AchaeaSystem.modules.offense')
local M      = {}
local Bus    = ci.Bus
local queue  = ci.queue
local affs   = ci.affs
local limbs  = ci.limbs

-- configuration --------------------------------------------------------------
local config = {
  softlockAffs   = { asthma=true, impatience=true, slickness=true, anorexia=true },
  finisherSkill  = "execute horrorstrike",
  finisherStacks = 4,
  limbOrder      = {'left_leg','right_leg','left_arm','right_arm','torso','head'},
}

-- runtime state --------------------------------------------------------------
local state = {
  target    = "target",
  horror    = 0,
  affs      = {},
  limbs     = {},
  killReady = nil,
  handlers  = {},
}

-- helpers -------------------------------------------------------------------
local function isSoftLocked()
  for a in pairs(config.softlockAffs) do
    if not state.affs[a] then return false end
  end
  return true
end

local function selectLimb()
  local snap = state.limbs or {}
  local best, hp = nil, 101
  for _,limb in ipairs(config.limbOrder) do
    local d = snap[limb]
    if d then
      if d.broken then return limb end
      if d.hp and d.hp < hp then best, hp = limb, d.hp end
    end
  end
  return best
end

local function updateHorror(n)
  if state.horror ~= n then
    state.horror = n
    Bus:fire("unnamable.horror", n)
  end
end

function M.addHorror() updateHorror(state.horror + 1) end
function M.removeHorror() updateHorror(math.max(0, state.horror - 1)) end
function M.resetHorror() updateHorror(0) end

function M.getMangledLimbs()
  local list = {}
  for limb,d in pairs(state.limbs) do
    if d.mangled then table.insert(list, limb) end
  end
  table.sort(list)
  return list
end

---Return true if a limb is broken.
---@param limb string
function M.isLimbBroken(limb)
  return state.limbs[limb] and state.limbs[limb].broken or false
end

---Return true if a limb is mangled.
---@param limb string
function M.isLimbMangled(limb)
  return state.limbs[limb] and state.limbs[limb].mangled or false
end

---Count mangled limbs on the current target.
function M.countMangledLimbs()
  local c = 0
  for _,d in pairs(state.limbs) do if d.mangled then c=c+1 end end
  return c
end

---Check if the target has at least two broken limbs.
function M.validExtinctionTarget()
  local b=0
  for _,d in pairs(state.limbs) do if d.broken then b=b+1 end end
  return b>=2
end

---Return true if disembowel conditions are met.
function M.shouldDisembowel()
  local aff = state.affs
  return (state.limbs.torso and state.limbs.torso.broken) and (aff.prone or aff.proned)
end

---Set desired finisher stack threshold.
function M.setFinisherStacks(n)
  n = tonumber(n)
  if n then config.finisherStacks = n end
end

---Change current target.
function M.setTarget(t)
  if t then state.target = t end
end

local function attemptAction()
  if isSoftLocked() and state.limbs.torso and state.limbs.torso.broken and
     state.horror >= config.finisherStacks then
    state.killReady = "extinction"
    queue.push(config.finisherSkill, {prio="high"})
    Bus:fire("unnamable.killwindow", state.killReady)
    return
  end

  if M.shouldDisembowel() then
    state.killReady = "disembowel"
    queue.push("disembowel "..state.target, {prio="high"})
    Bus:fire("unnamable.killwindow", state.killReady)
    return
  end

  state.killReady = nil
  Offense.decide{affs=state.affs, limbs=state.limbs}
end

-- event handlers ------------------------------------------------------------
local function onAff(e)
  state.affs = e.affs or e
  attemptAction()
end

local function onLimb(target, snap)
  if not target or target == state.target then
    state.limbs = snap or {}
    attemptAction()
  end
end

local function onHorror(n)
  updateHorror(n)
  attemptAction()
end

  ---Register event handlers for afflictions, limb updates and horror changes.
  function M.register()
    if state.handlers.aff then return end
  state.handlers.aff    = Bus:on("aff.update", onAff)
  state.handlers.limb   = Bus:on("limb.update", onLimb)
  state.handlers.horror = Bus:on("horror.updated", onHorror)
end

  ---Unregister all event handlers for hot-reload safety.
  function M.unregister()
  for _,h in pairs(state.handlers) do Bus:off(h) end
  state.handlers = {}
end

  ---Initialise and register default handlers.
  function M.init()
    M.register()
  end

  ---Run decision logic once using optional state overrides.
  ---@param opts table|nil {affs=table, limbs=table, target=string, horror=number}
  function M.decide(opts)
  opts = opts or {}
  state.affs   = opts.affs   or state.affs
  state.limbs  = opts.limbs  or state.limbs
  state.target = opts.target or state.target
  state.horror = opts.horror or state.horror
  attemptAction()
end

return M
