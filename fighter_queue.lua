local q = {list={}, paused=false}

function q.push(cmd,opt)
  if not cmd or cmd=="" then return end
  table.insert(q.list, cmd)
  if not q.paused then send(cmd) end
end

function q.pause(state)
  if state~=nil then q.paused=state else q.paused=not q.paused end
end

function q.clear()
  q.list={}
end

function q.size()
  return #q.list
end

return q
