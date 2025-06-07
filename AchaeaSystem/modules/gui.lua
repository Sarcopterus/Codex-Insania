local Geyser = require 'Geyser'
local Bus    = ci.Bus
local win    = Geyser.Label:new({name='ci_gui',x='70%',y='60%',width='30%',height='12%'})

local limbs = {'head','torso','left_arm','right_arm','left_leg','right_leg'}

local function render()
  local a   = ci.affs.list and ci.affs.list('target') or {}
  local soft= (a.asthma and a.impatience and a.slickness and a.anorexia) and 'YES' or 'NO'
  local stat= ci.limbs.status and ci.limbs.status('target') or {}
  local info = {}
  for _,limb in ipairs(limbs) do
    local d = stat[limb] or {}
    table.insert(info, string.format('%s:%s%s', limb, d.hp or 100, d.broken and '!' or ''))
  end
  win:clear()
  win:echo(string.format('<lime>Soft-lock: %s\n<white>%s\n<yellow>Last: %s', soft, table.concat(info,' '), ci.queue.last and ci.queue.last() or ' '))
end

function win:init() render() end

local M = { handlers={} }

function M.init()
  if M.handlers.bus then return end
  M.handlers.bus = {
    Bus:on('queue.sent', render),
    Bus:on('aff.update', render),
    Bus:on('limb.update', render)
  }
end

return M
