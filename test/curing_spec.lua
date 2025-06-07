local sent = {}
AchaeaSystem = {queue={push=function(cmd) table.insert(sent, cmd) end}, bus={fire=function()end}}
ci = AchaeaSystem
local curing = require('AchaeaSystem.modules.curing')
curing.enable()
assert(sent[#sent] == 'CURING ON')
curing.insertPriority('asthma',1)
assert(sent[#sent] == 'CURING PRIORITY INSERT asthma 1')
print('curing_spec ok')
