--[[
Unnamable SnB specific combat logic
Handles horror stacks and finisher skills.

Usage:
  local u = require('AchaeaSystem.modules.pvp.unnamable')
  u.register()
  u.addHorror()
  u.extinction('enemy')
  u.unregister()

Events:
  - custom "horror gained" event for stack tracking
  - publishes "horror_gain" when stacks increase
Shared state:
  unnamable.horror - current stack count
]]

local unnamable = {
  config = {
    autoFinisher = true,
    finisherThreshold = 5,
    autoCatastrophe = true,
  },
  handlers = {},
  horror = 0,
  killReady = nil,
  prevAffs = {},
}

local Bus = ci.Bus

-- utility wrappers around the limb tracker ------------------------------
local function status(target)
  return ci.limbs.status and ci.limbs.status(target) or {}
end

function unnamable:isLimbBroken(limb)
  local s = status(self.target or (ci.modules and ci.modules.targeting and ci.modules.targeting.get()) or 'target')
  return s[limb] and s[limb].broken
end

function unnamable:isLimbMangled(limb)
  local s = status(self.target or (ci.modules and ci.modules.targeting and ci.modules.targeting.get()) or 'target')
  return s[limb] and s[limb].mangled
end

function unnamable:countMangledLimbs()
  local t = 0
  local s = status(self.target or (ci.modules and ci.modules.targeting and ci.modules.targeting.get()) or 'target')
  for _,d in pairs(s) do if d.mangled then t = t + 1 end end
  return t
end

function unnamable:getMangledLimbs()
  local list = {}
  local s = status(self.target or (ci.modules and ci.modules.targeting and ci.modules.targeting.get()) or 'target')
  for limb,d in pairs(s) do if d.mangled then table.insert(list, limb) end end
  table.sort(list)
  return list
end

function unnamable:validExtinctionTarget()
  local s = status(self.target or (ci.modules and ci.modules.targeting and ci.modules.targeting.get()) or 'target')
  local b = 0
  for _,d in pairs(s) do if d.broken then b = b + 1 end end
  return b >= 2
end

function unnamable.shouldDisembowel()
  local tgt = ci.modules and ci.modules.targeting and ci.modules.targeting.get() or 'target'
  local s = status(tgt)
  local affs = ci.affs.list and ci.affs.list(tgt) or {}
  return (s.torso and s.torso.broken) and (affs.prone or affs.proned)
end

-------------------------------------------------------------------------
local function updateStacks(n)
  if n == unnamable.horror then return end
  unnamable.horror = n
  ci.Bus:fire('horror.updated', n)
end

function unnamable.addHorror()
  updateStacks(unnamable.horror + 1)
end

function unnamable.removeHorror()
  updateStacks(math.max(0, unnamable.horror - 1))
end

function unnamable.handleHorrorEvent()
  unnamable.addHorror()
end

local function handleAffUpdate(e)
  local affs = e.affs or e
  if affs.horror and not unnamable.prevAffs.horror then
    unnamable.addHorror()
  elseif not affs.horror and unnamable.prevAffs.horror then
    unnamable.removeHorror()
  end
  unnamable.prevAffs = affs
end

function unnamable.resetHorror()
  updateStacks(0)
end

function unnamable.resetKillpath()
  unnamable.killReady = nil
end

local function fireKillEvent(evt, skill)
  ci.Bus:fire(evt, skill)
  unnamable.killReady = skill
end

function unnamable.checkFinisher()
  local tmod = ci.modules and ci.modules.targeting
  local target = tmod and tmod.get() or 'target'
  local stat = status(target)
  local affs = ci.affs.list and ci.affs.list(target) or {}
  local ready

  if unnamable.horror >= unnamable.config.finisherThreshold and unnamable:validExtinctionTarget() then
    ready = 'extinction'
  elseif unnamable:countMangledLimbs() >= 2 and (unnamable:isLimbMangled('left_arm') or unnamable:isLimbMangled('right_arm')) then
    ready = 'catastrophe'
  elseif unnamable.shouldDisembowel() then
    ready = 'disembowel'
  end

  if ready then
    fireKillEvent('killpath.ready', ready)
    if ci.pvp and ci.pvp.auto then
      local cmd = ready
      if ready == 'extinction' then cmd = 'extinction '..target end
      if ready == 'catastrophe' then cmd = 'catastrophe '..target end
      if ready == 'disembowel' then cmd = 'disembowel '..target end
      ci.queue.push(cmd, {prio='high'})
      fireKillEvent('killpath.fired', ready)
    end
  end
end

function unnamable.setThreshold(n)
  n = tonumber(n)
  if n then unnamable.config.finisherThreshold = n end
end

function unnamable.extinction(target)
  AchaeaSystem.queue.push("extinction " .. (target or ""))
end

function unnamable.catastrophe(target)
  AchaeaSystem.queue.push("catastrophe " .. (target or ""))
end

function unnamable.applyStrategy(strat)
  strat = strat and strat:lower() or ''
  if strat == 'serpent' then
    ci.queue.push('curing prioaff hypochondria')
    ci.queue.push('curing priority insert impatience 1')
  elseif strat == 'shaman' then
    ci.queue.push('curing prioaff epilepsy')
  end
end

function unnamable.register()
  if unnamable.handlers.horror then return end
  unnamable.handlers.horror = AchaeaSystem.subscribe('horror_gain', 'AchaeaSystem.modules.pvp.unnamable.handleHorrorEvent')
  unnamable.handlers.limb = AchaeaSystem.on('limb.update', 'AchaeaSystem.modules.pvp.unnamable.checkFinisher')
  unnamable.handlers.aff  = AchaeaSystem.on('aff.update', handleAffUpdate)
  unnamable.handlers.gold = tempRegexTrigger('^You eat some (goldenseal|plumbum)', 'AchaeaSystem.modules.pvp.unnamable.removeHorror')
  unnamable.handlers.strat = Bus:on('pvp.strategy.changed', function(class)
    if class == 'serpent' then
      ci.queue.push('curing prioaff hypochondria')
      ci.queue.push('curing priority insert impatience 1')
    elseif class == 'shaman' then
      ci.queue.push('curing prioaff epilepsy')
    end
  end)
end

function unnamable.unregister()
  if unnamable.handlers.horror then AchaeaSystem.unsubscribe(unnamable.handlers.horror) end
  if unnamable.handlers.limb then AchaeaSystem.off(unnamable.handlers.limb) end
  if unnamable.handlers.aff then AchaeaSystem.off(unnamable.handlers.aff) end
  if unnamable.handlers.gold then killTrigger(unnamable.handlers.gold) end
  if unnamable.handlers.strat then Bus:off(unnamable.handlers.strat) end
  unnamable.handlers = {}
end

function unnamable.init()
  unnamable.register()
  if ci.pvp and ci.pvp.strategy then
    Bus:fire('pvp.strategy.changed', ci.pvp.strategy)
  end
end

return unnamable
