AchaeaSystem = {modules={}, on=function()end, off=function()end}
ci = AchaeaSystem
Bus = {fire=function()end}
ci.Bus = Bus
getStopWatchTime = function() return 0 end
tempTimer = function(sec, fn) return 1 end
killTimer = function(id) end

local cd = require('AchaeaSystem.modules.cooldowns')
cd.start('extinction', 5)
assert(cd.remaining('extinction') <= 5 and cd.remaining('extinction') >= 4.9)
print('cooldowns_spec ok')
