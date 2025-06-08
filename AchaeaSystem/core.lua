--[[
Codex-Insania core
Initialises all modules and wires up GMCP handlers.
Designed for full modularity using Mudlet packages.
]]

AchaeaSystem = AchaeaSystem or {}
ci = AchaeaSystem
AchaeaSystem.modules = AchaeaSystem.modules or {}
require("AchaeaSystem.core.debug_guard")

--[[
Event utilities
---------------
`registerEventHandler(event, handler)` wraps Mudlet's anonymous event
registration. `unregisterEventHandler(id)` removes the handler.
]]

function AchaeaSystem.registerEventHandler(event, handler)
  return registerAnonymousEventHandler(event, handler)
end

function AchaeaSystem.unregisterEventHandler(id)
  if id then killAnonymousEventHandler(id) end
end

-- Backwards compatibility aliases
AchaeaSystem.on = AchaeaSystem.registerEventHandler
AchaeaSystem.off = AchaeaSystem.unregisterEventHandler

-- Utility to load modules dynamically
local function loadModule(modname)
  local ok, mod = pcall(require, modname)
  if ok and type(mod) == 'table' then
    return mod
  else
    cecho(string.format("<red>Failed loading %s: %s", modname, mod))
    return nil
  end
end

-- Load core data tables
AchaeaSystem.afflictions = loadModule("AchaeaSystem.data.afflictions")
AchaeaSystem.defences = loadModule("AchaeaSystem.data.defences")
AchaeaSystem.mapping = loadModule("AchaeaSystem.data.mapping")

-- Module loaders
AchaeaSystem.queue = loadModule("AchaeaSystem.core.queue")
AchaeaSystem.limbs = loadModule("AchaeaSystem.core.limbs")
AchaeaSystem.docs = loadModule("AchaeaSystem.core.docs")

require("AchaeaSystem.core.bus")

local mods = {
  "core.cureTables",
  "modules.curing",
  "modules.afftracker",
  "modules.cooldowns",
  "modules.targeting",
  "modules.area",
  "modules.autoCure",
  "modules.offense",
  "modules.groupComms",
  "modules.gui",
}
for _,m in ipairs(mods) do
  local full = "AchaeaSystem." .. m
  local ok, mod = pcall(require, full)
  if not ok then
    cecho(string.format("<red>Failed loading %s: %s\n", full, mod))
  elseif type(mod) == "table" then
    AchaeaSystem.modules[m] = mod
    if mod.init then
      local ok2, err = pcall(mod.init)
      if not ok2 then
        cecho(string.format("<red>Error initializing %s: %s\n", full, err))
      end
    end
  end
end

-- GMCP initialisation
function AchaeaSystem.init()
  sendGMCP("Core.Supports.Add [Char 1,Char.Defences 1,Char.Afflictions 1,IRE.Rift 1]")
  if AchaeaSystem.limbs and AchaeaSystem.limbs.register then
    AchaeaSystem.limbs.register()
  end
end

tempTimer(0, AchaeaSystem.init)

-- Modules register their own handlers inside their files. This ensures
-- clean separation and the ability to unload modules without side effects.

return AchaeaSystem
