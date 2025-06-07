local H   = {
  kelp       = { "asthma","clumsiness","hypochondria","sensitivity",
                 "weariness","healthleech","parasite","rebbies" },
  ginseng    = { "addiction","darkshade","haemophilia","lethargy",
                 "nausea","scytherus","flushings" },
  goldenseal = { "dizziness","epilepsy","impatience","shyness","stupidity",
                 "depression","shadowmadness","mycalium","sandfever","horror",
               },
  lobelia    = { "agoraphobia","guilt","spiritburn","tenderskin","claustrophobia",
                 "loneliness","masochism","recklessness","vertigo" },
  ash        = { "confusion","dementia","hallucinations","hypersomnia","paranoia" },
  bellwort   = { "retribution","timeloop","peace","justice","lovers" },
}

local salves = {
  "mass","restore","mending","regeneration","soothing","epidermal",
}
local focus  = { "impatience","stupidity","shyness","paranoia","hallucinations",
                 "mayhem","loneliness","hypersomnia",
}

local function contains(t,val) for _,v in ipairs(t) do if v == val then return true end end end
local function hasAny(stack, affs)
  for _,a in ipairs(stack) do if affs[a] then return true end end
end

ci           = ci or {}
ci.curing    = {}

function ci.curing.nextHerb(affs)
  for herb,stack in pairs(H) do
    if hasAny(stack, affs) then return herb end
  end
end

function ci.curing.nextSalve(affs)
  for _,s in ipairs(salves) do if affs[s] then return s end end
end

function ci.curing.shouldFocus(affs)
  for _,a in ipairs(focus) do if affs[a] then return true end end
end

function ci.curing.shouldEat(affs)  return ci.curing.nextHerb(affs) ~= nil end

return ci.curing
