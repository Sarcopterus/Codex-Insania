---Unnamable class interface.
--This thin wrapper delegates combat decisions to the PvP module so the brain
--can load classes uniformly.
local mod = require('AchaeaSystem.modules.pvp.unnamable')

local M = {}

---Run the class decision logic.
---@param state table|nil optional overrides
function M.decide(state)
  mod.decide(state)
end

return M
