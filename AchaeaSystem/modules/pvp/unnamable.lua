--[[
Unnamable SnB specific combat logic
]]

local unnamable = {}

unnamable.horror = 0

function unnamable.addHorror()
  unnamable.horror = unnamable.horror + 1
end

function unnamable.resetHorror()
  unnamable.horror = 0
end

function unnamable.extinction(target)
  send("extinction " .. (target or ""))
end

return unnamable
