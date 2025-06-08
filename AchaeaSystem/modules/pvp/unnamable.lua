-- Unnamable SnB combat automation, Codex-Insania style.
-- Provides limb prep and finisher logic using ci.Bus events and ci.queue.

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
  limbOrder      = {"left leg","right leg","left arm","right arm","torso","head"},
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

local function attemptAction()
  if isSoftLocked() and state.limbs.torso and state.limbs.torso.broken and
     state.horror >= config.finisherStacks then
    state.killReady = "extinction"
    queue.push(config.finisherSkill, {prio="high"})
    Bus:fire("unnamable.killwindow", state.killReady)
    return
  end
  state.killReady = nil
  local limb = selectLimb()
  if limb then
    local cmd = string.format("whiplash %s %s", state.target, limb)
    queue.push(cmd, {prio="normal"})
    Bus:fire("unnamable.action", cmd)
  end
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

---Register event handlers and start automation.
function M.register()
  if state.handlers.aff then return end
  state.handlers.aff    = Bus:on("aff.update", onAff)
  state.handlers.limb   = Bus:on("limb.update", onLimb)
  state.handlers.horror = Bus:on("horror.updated", onHorror)
end

---Unregister all event handlers.
function M.unregister()
  for _,h in pairs(state.handlers) do Bus:off(h) end
  state.handlers = {}
end

---Initialise the Unnamable module.
function M.init()
  M.register()
end

---Decision helper for external class interface.
---@param opts table|nil optional state overrides
function M.decide(opts)
  opts = opts or {}
  state.affs   = opts.affs   or state.affs
  state.limbs  = opts.limbs  or state.limbs
  state.target = opts.target or state.target
  state.horror = opts.horror or state.horror
  attemptAction()
end

return M
