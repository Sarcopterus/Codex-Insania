local ok,Geyser = pcall(require,'Geyser')
if not ok then return {init=function()end} end
local Bus = ci.Bus
local panel = require('AchaeaSystem.ui.unnamable_panel')

local win = Geyser.Container:new({name='ci_gui',x='70%',y='60%',width='30%',height='18%'})
local info = Geyser.Label:new({name='ci_gui_info',x='0%',y='0%',width='100%',height='35%'},win)
local limbArea = Geyser.Container:new({name='ci_gui_limb',x='0%',y='35%',width='100%',height='40%'},win)
local affBox = Geyser.Label:new({name='ci_gui_aff',x='0%',y='75%',width='100%',height='15%'},win)
local killBox = Geyser.Label:new({name='ci_gui_kill',x='0%',y='90%',width='100%',height='10%'},win)

local limbPos={
  head={x='40%',y='0%'}, torso={x='40%',y='20%'},
  left_arm={x='0%',y='20%'}, right_arm={x='80%',y='20%'},
  left_leg={x='0%',y='40%'}, right_leg={x='80%',y='40%'}
}
local limbLabels={}
for limb,pos in pairs(limbPos) do
  limbLabels[limb]=Geyser.Label:new({name='ci_limb_'..limb,x=pos.x,y=pos.y,width='20%',height='20%'},limbArea)
end

local affHistory={}
local prevAffs={}
local softAffs={asthma=true,impatience=true,slickness=true,anorexia=true}

local function updateAffHistory()
  local cur=ci.affs.list and ci.affs.list('target') or {}
  for aff in pairs(cur) do
    if not prevAffs[aff] then
      table.insert(affHistory,1,aff)
      if #affHistory>5 then table.remove(affHistory) end
    end
  end
  prevAffs=cur
end

local limbs={'head','torso','left_arm','right_arm','left_leg','right_leg'}

local function updatePanel()
  if not panel.update then return end
  local u = AchaeaSystem.modules and AchaeaSystem.modules.pvp and AchaeaSystem.modules.pvp.unnamable
  if not u then return end
  local status='Waiting'
  if u.killReady=='extinction' then status='Extinction Ready'
  elseif u.killReady=='catastrophe' then status='Catastrophe Ready'
  elseif u.killReady=='disembowel' then status='Disembowel Ready' end
  local limbsList = u.getMangledLimbs and u:getMangledLimbs() or {}
  panel.update(u.horror or 0,status,limbsList)
end

local function render()
  local targetMod=AchaeaSystem.modules and AchaeaSystem.modules.targeting
  local tgt=targetMod and targetMod.get() or 'target'
  local stat=ci.limbs.status and ci.limbs.status(tgt) or {}
  for _,limb in ipairs(limbs) do
    local d=stat[limb] or {}
    limbLabels[limb]:echo(string.format('%s:%d%s',limb,d.hp or 100,d.broken and '!' or ''))
  end
  local a=ci.affs.list and ci.affs.list('target') or {}
  local soft=(a.asthma and a.impatience and a.slickness and a.anorexia) and 'YES' or 'NO'
  local curing=AchaeaSystem.modules and AchaeaSystem.modules.curing
  local ssc=curing and (curing.enabled and 'ON' or 'OFF') or 'n/a'
  local cdMod=AchaeaSystem.modules and AchaeaSystem.modules.cooldowns
  local cds={}
  if cdMod and cdMod.timers then
    for s,_ in pairs(cdMod.timers) do table.insert(cds,s..':'..string.format('%.1f',cdMod.remaining(s))) end
  end
  local cdStr=table.concat(cds,' ')
  local qsize=ci.queue.size and ci.queue.size() or 0
  local u=AchaeaSystem.modules and AchaeaSystem.modules.pvp and AchaeaSystem.modules.pvp.unnamable
  local horror=u and u.horror or 0
  info:clear()
  info:echo(string.format('<lime>Curing:%s Soft:%s Target:%s CD:%s Queue:%d Horror:%d',ssc,soft,tgt,cdStr,qsize,horror))
  local lines={}
  for i,aff in ipairs(affHistory) do
    local color=(a[aff] and softAffs[aff]) and '<red>' or (a[aff] and '<yellow>' or '')
    table.insert(lines,color..aff)
  end
  affBox:echo(table.concat(lines,' '))
  local mlist=u and u.getMangledLimbs and u:getMangledLimbs() or {}
  local ready=u and u.killReady or ''
  killBox:echo(string.format('Mangled:%s Ready:%s',table.concat(mlist,' '),ready or ''))
end

function win:init() render() end

local M={handlers={}}

function M.init()
  if M.handlers.bus then return end
  M.handlers.bus={
    Bus:on('queue.sent',function() render(); updatePanel() end),
    Bus:on('aff.update',function() updateAffHistory(); render(); updatePanel() end),
    Bus:on('limb.update',function() render(); updatePanel() end),
    Bus:on('target.changed',function() render(); updatePanel() end),
    Bus:on('cooldown.gained',function() render(); updatePanel() end),
    Bus:on('cooldown.expired',function() render(); updatePanel() end),
    Bus:on('horror.updated',function() render(); updatePanel() end),
    Bus:on('killpath.ready',updatePanel),
    Bus:on('killpath.fired',updatePanel)
  }
  updateAffHistory()
  render()
  panel.init()
  updatePanel()
end

function M.unregister()
  if not M.handlers.bus then return end
  for _,h in ipairs(M.handlers.bus) do Bus:off(h) end
  M.handlers.bus=nil
  win:hide()
end

return M
