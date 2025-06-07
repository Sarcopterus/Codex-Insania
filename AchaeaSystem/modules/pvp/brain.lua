--- @docs PvP brain loop feeding class modules
local brain = {classMod=nil, timer=nil, target=nil, currentClass='unnamable'}

local function pathFor(class)
  return 'AchaeaSystem/classes/'..class..'.lua'
end

function brain.loadClass(class)
  local ok, mod = pcall(dofile, pathFor(class))
  if ok and type(mod)=='table' then
    brain.classMod = mod
    brain.currentClass = class
    cecho(string.format('<green>Loaded class %s\n', class))
  elseif class ~= 'unnamable' then
    cecho('<red>No class module, falling back to unnamable\n')
    brain.loadClass('unnamable')
  end
end

function brain.loop()
  if brain.classMod and brain.classMod.decide then
    local affs = AchaeaSystem.modules.offense.affs or {}
    brain.classMod.decide({target=brain.target}, AchaeaSystem.modules.curing.defences or {}, AchaeaSystem.limbs, affs)
  end
end

function brain.start(target)
  brain.target = target
  if brain.timer then killTimer(brain.timer) end
  brain.timer = tempTimer(0.1, [[AchaeaSystem.modules.pvp.brain.loop()]], true)
end

function brain.stop()
  if brain.timer then killTimer(brain.timer) brain.timer=nil end
end

function brain.init()
  brain.loadClass(brain.currentClass)
end

function brain.setClass(cls)
  brain.loadClass(cls)
end

return brain
