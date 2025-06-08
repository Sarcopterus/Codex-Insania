local mod = require('AchaeaSystem.modules.pvp.unnamable')
return {
  ---Delegate decision making to the Unnamable PvP module.
  ---@param state table|nil optional state overrides
  decide = function(state) mod.decide(state) end
}
