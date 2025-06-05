--[[
AchaeaSystem core module
Initialises system, loads modules and handles GMCP events.
Based on Legacy and SVOF best practices.
]]

AchaeaSystem = AchaeaSystem or {}
AchaeaSystem.modules = {}

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
AchaeaSystem.modules.curing = loadModule("AchaeaSystem/modules/curing.lua")
AchaeaSystem.modules.pve = loadModule("AchaeaSystem/modules/pve.lua")
AchaeaSystem.modules.group = loadModule("AchaeaSystem/modules/group.lua")
AchaeaSystem.modules.gui = loadModule("AchaeaSystem/modules/gui.lua")
AchaeaSystem.modules.pvp = {}
AchaeaSystem.modules.pvp.combat = loadModule("AchaeaSystem/modules/pvp/combat.lua")
AchaeaSystem.modules.pvp.unnamable = loadModule("AchaeaSystem/modules/pvp/unnamable.lua")

-- GMCP initialisation
function AchaeaSystem.init()
  installPackage = installPackage or function() end -- placeholder for installer
  sendGMCP("Core.Supports.Add [Char 1,Char.Defences 1,Char.Afflictions 1,IRE.Rift 1]")
  if AchaeaSystem.modules.gui and AchaeaSystem.modules.gui.init then
    AchaeaSystem.modules.gui.init()
  end
end

tempTimer(0, AchaeaSystem.init)

-- Example GMCP handler registration
registerAnonymousEventHandler("gmcp.Char", "AchaeaSystem.modules.curing.handleChar")
registerAnonymousEventHandler("gmcp.Char.Afflictions", "AchaeaSystem.modules.curing.handleAffs")
registerAnonymousEventHandler("gmcp.Char.Defences", "AchaeaSystem.modules.curing.handleDefences")
registerAnonymousEventHandler("gmcp.IRE.Rift", "AchaeaSystem.modules.curing.handleRift")

return AchaeaSystem
