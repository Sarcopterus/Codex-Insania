local M = {}

local function softlock()
  return ci.affs.hasAll and ci.affs.hasAll{"asthma","impatience","slickness","anorexia"}
end

function M.decide()
  if softlock() and ci.limbs.isBroken and ci.limbs.isBroken("torso") then
    return "execute horrorstrike"
  end
  local limb = ci.limbs.nextPrep and ci.limbs.nextPrep({"left leg","right leg","torso"})
  if limb then
    return "whiplash "..(ci.group and ci.group.target or "").." "..limb
  end
end

return M