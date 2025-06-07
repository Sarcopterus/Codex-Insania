--- @docs Simple action queue for pacing commands
local queue = {
  list = {},
  paused = false,
  timer = nil,
  lastCmd = nil,
}

function queue.process()
  if queue.paused or queue.timer or #queue.list == 0 then return end
  queue.timer = tempTimer(0, function()
    queue.timer = nil
    local cmd = table.remove(queue.list, 1)
    if cmd then
      queue.lastCmd = cmd
      send(cmd)
      if ci and ci.Bus and ci.Bus.fire then
        ci.Bus:fire("queue.sent", cmd)
      end
    end
    queue.process()
  end)
end

function queue.push(cmd)
  if not cmd or cmd == '' then return end
  table.insert(queue.list, cmd)
  queue.process()
end

function queue.pause(state)
  if state ~= nil then queue.paused = state else queue.paused = not queue.paused end
end

function queue.clear()
  queue.list = {}
  if queue.timer then killTimer(queue.timer) queue.timer = nil end
end

function queue.size()
  return #queue.list
end

function queue.last()
  return queue.lastCmd
end

return queue
