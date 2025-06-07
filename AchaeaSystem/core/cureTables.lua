--[[
Curing priority tables derived from Legacy.
Provides helpers for herb decisions.
]]

ci = ci or {}
ci.curing = ci.curing or {}
local M = ci.curing

-- priority orders baked from legacy_core.lua
M.herbOrder = {"kelp","ginseng","goldenseal","lobelia","ash","bellwort"}
M.salveOrder = {"mass","restore","mending","regeneration","soothing","epidermal"}
M.focusOrder = {"impatience","stupidity","shyness","paranoia","hallucinations","mayhem","loneliness","hypersomnia"}

-- herb stacks
local stacks = {
  kelp = {"asthma","clumsiness","hypochondria","sensitivity","weariness","healthleech","parasite","rebbies"},
  ginseng = {"addiction","darkshade","haemophilia","lethargy","nausea","scytherus","flushings"},
  goldenseal = {"dizziness","epilepsy","impatience","shyness","stupidity","depression","shadowmadness","mycalium","sandfever","horror"},
  lobelia = {"agoraphobia","guilt","spiritburn","tenderskin","claustrophobia","loneliness","masochism","recklessness","vertigo"},
  ash = {"confusion","dementia","hallucinations","hypersomnia","paranoia"},
  bellwort = {"retribution","timeloop","peace","justice","lovers"},
}

---Return the herb to eat next based on priority order.
---@param affs table<string,boolean>
---@return string|nil
function M.nextHerb(affs)
  for _,herb in ipairs(M.herbOrder) do
    local list = stacks[herb]
    for i=1,#list do
      if affs[list[i]] then return herb end
    end
  end
end

---Determine if an herb should be eaten right now.
---@param affs table<string,boolean>
---@return boolean
function M.shouldEat(affs)
  return M.nextHerb(affs) ~= nil
end

return M
