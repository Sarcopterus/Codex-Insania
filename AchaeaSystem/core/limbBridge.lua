--[[
Bridge for Romaen's limb tracker v1.3
Parses limb hp data and exposes helper methods.
]]
local tracker = require('limb_v1_3')

ci = ci or {}
ci.limbs = ci.limbs or {}

---Return status table for a target.
---@param target string
---@return table
function ci.limbs.status(target)
  return tracker.status(target)
end

---Return the limb most prepared but not broken.
---@param target string
---@return string|nil
function ci.limbs.bestPrep(target)
  local stat = ci.limbs.status(target)
  local name, hp = nil, 101
  for limb,data in pairs(stat) do
    if not data.broken and data.hp < hp then
      hp = data.hp
      name = limb
    end
  end
  return name
end

return ci.limbs
