local ok,Geyser = pcall(require,'Geyser')
if not ok or not Geyser then return end

local panel = {win=nil, labels={}}

function panel.init()
  if panel.win then return end
  panel.win = Geyser.Container:new({name='ci_u_panel',x='70%',y='40%',width='30%',height='10%'})
  panel.labels.horror = Geyser.Label:new({name='ci_u_horror',x='0%',y='0%',width='100%',height='33%'},panel.win)
  panel.labels.status = Geyser.Label:new({name='ci_u_status',x='0%',y='33%',width='100%',height='33%'},panel.win)
  panel.labels.limbs  = Geyser.Label:new({name='ci_u_limbs',x='0%',y='66%',width='100%',height='34%'},panel.win)
end

local function join(tbl)
  return table.concat(tbl,' ')
end

function panel.update(horror,status,limbs)
  if not panel.win then return end
  panel.labels.horror:echo(string.format('Horror: %d', horror or 0))
  panel.labels.status:echo(status or 'Waiting')
  panel.labels.limbs:echo('Mangled: '..join(limbs or {}))
end

return panel
