local Geyser = require "Geyser"
local win    = Geyser.Label:new({name="ci_gui",x="70%",y="60%",width="30%",height="10%"})
local function render()
  local a     = ci.affs.snapshot()
  local soft  = (a.asthma and a.impatience and a.slickness and a.anorexia) and "YES" or "no"
  local limb  = ci.limbs.snapshot() or {}
  local torso = limb.torso and (limb.torso.broken and "BROKEN" or limb.torso.hp.."%") or "?"
  win:echo(string.format("<lime>Soft-lock: %s\n<white>Torso: %s\n<yellow>Last: %s",
            soft, torso, ci.queue.last() or " "))
end
ci.Bus:on("queue.sent", render)
ci.Bus:on("aff.update", render)
ci.Bus:on("limb.update",render)

function win:init() render() end
return { init = function() end }