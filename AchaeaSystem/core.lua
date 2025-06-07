--[[
Codex-Insania core
Initialises all modules and wires up GMCP handlers.
Designed for full modularity using Mudlet packages.
]]

AchaeaSystem = AchaeaSystem or {}
ci = AchaeaSystem

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
local function loadModule(path)
  local ok, mod = pcall(dofile, path)
  if ok and type(mod) == 'table' then
    return mod
  else
    cecho(string.format("<red>Failed loading %s: %s", path, mod))
    return nil
  end
end

-- Load core data tables
AchaeaSystem.afflictions = dofile("AchaeaSystem/data/afflictions.lua")
AchaeaSystem.defences = dofile("AchaeaSystem/data/defences.lua")
AchaeaSystem.mapping = dofile("AchaeaSystem/data/mapping.lua")

-- Module loaders
AchaeaSystem.queue = loadModule("AchaeaSystem/core/queue.lua")
AchaeaSystem.limbs = loadModule("AchaeaSystem/core/limbs.lua")
AchaeaSystem.docs = loadModule("AchaeaSystem/core/docs.lua")

local mods = {
  "core.bus",
  "core.cureTables",
  "modules.autoCure",
  "modules.offense",
  "modules.gui",
}
for _,m in ipairs(mods) do
  require("AchaeaSystem."..m)
end

-- GMCP initialisation
function AchaeaSystem.init()
  sendGMCP("Core.Supports.Add [Char 1,Char.Defences 1,Char.Afflictions 1,IRE.Rift 1]")
  if AchaeaSystem.docs and AchaeaSystem.docs.generate then AchaeaSystem.docs.generate() end
  if AchaeaSystem.limbs and AchaeaSystem.limbs.register then
    AchaeaSystem.limbs.register()
  end
end

tempTimer(0, AchaeaSystem.init)

-- Modules register their own handlers inside their files. This ensures
-- clean separation and the ability to unload modules without side effects.

return AchaeaSystem