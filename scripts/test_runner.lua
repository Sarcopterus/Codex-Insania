local default = {
  head = {hp=100,broken=false},
  torso = {hp=100,broken=false},
  left_arm = {hp=100,broken=false},
  right_arm = {hp=100,broken=false},
  left_leg = {hp=100,broken=false},
  right_leg = {hp=100,broken=false},
}

function limb.status(target)
  return limb.targets[target] or default
end

function limb.update(target, data)
  limb.targets[target] = data
end

limb.thresholds = {break_at=0, prep_at=60}

return limb