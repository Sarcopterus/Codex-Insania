local Bus   = ci.Bus
local queue = ci.queue
local limbs = ci.limbs
local affs  = ci.affs or {}

local Config = {
  softLockFinisher = 'execute horrorstrike',
  prepSequence = {'left_leg','right_leg','left_arm','right_arm','torso','head'},
}

local M = {h1=nil,h2=nil}

local function isSoftLocked(a)
  return a.asthma and a.impatience and a.slickness and a.anorexia
end

---Decide and queue the next offensive action.
---@param state table {affs=table, limbs=table}
---@return string|nil command queued
function M.decide(state)
  state = state or {}
  local a = state.affs or {}
  local l = state.limbs or {}
  if isSoftLocked(a) and l.torso and l.torso.broken then
    queue.push(Config.softLockFinisher,{prio='high'})
    return Config.softLockFinisher
  end

  local best, hp = nil, 101
  for _,limb in ipairs(Config.prepSequence) do
    local d = l[limb]
    if d and not d.broken and d.hp < hp then
      hp = d.hp
      best = limb
    end
  end
  if best then
    local target = ci.group and ci.group.target or 'target'
    local cmd = string.format('strike %s %s', target, best)
    queue.push(cmd,{prio='high'})
    return cmd
  end
end

local function handle()
  local t = ci.group and ci.group.target or 'target'
  local a = affs.list and affs.list(t) or {}
  local l = limbs.status and limbs.status(t) or {}
  M.decide{affs=a, limbs=l}
end

---Initialise offense event handlers.
function M.init()
  if M.h1 then return end
  M.h1 = Bus:on('aff.update', handle)
  M.h2 = Bus:on('limb.update', handle)
end

return M