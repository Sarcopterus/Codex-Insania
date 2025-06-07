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

--- Returns true if any affliction in `affs` is cured by the given herb.
---@param affs table @{aff=true}
---@param herb string
function ci.curing.shouldEat(affs, herb)
  if herb then
    local stack = H[herb]
    if not stack then return false end
    return hasAny(stack, affs)
  else
    return ci.curing.nextHerb(affs) ~= nil
  end
end

--- Returns the next cure of a given `kind` needed.
---@param affs table @{aff=true}
---@param kind string 'herb'|'salve'|'focus'
function ci.curing.nextCure(affs, kind)
  if kind == "herb"   then return ci.curing.nextHerb(affs)
  elseif kind == "salve" then return ci.curing.nextSalve(affs)
  elseif kind == "focus" then return ci.curing.shouldFocus(affs) and "focus" or nil
  end
end

return ci.curing
