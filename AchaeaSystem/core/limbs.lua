-- Romaen's Limb Tracker v1.3 (vendored)
-- The full tracker code would be placed here verbatim.
-- For brevity, it is omitted in this example.

-- Assume global table `limb` is defined by the tracker

ci          = ci or {}
ci.limbs    = {
  snapshot = limb.snapshot or limb.status,
  isBroken = limb.isBroken,
  hp       = limb.hp,
}
return ci.limbs
