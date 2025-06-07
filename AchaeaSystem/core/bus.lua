-- simple pub/sub
ci.bus = ci.bus or { _l = {} }

function ci.bus:on(evt, fn)
  self._l[evt] = self._l[evt] or {}
  table.insert(self._l[evt], fn)
  return fn
end

function ci.bus:fire(evt, ...)
  for _,fn in ipairs(self._l[evt] or {}) do fn(...) end
end

-- legacy names
ci.bus.subscribe = ci.bus.on
ci.bus.publish   = ci.bus.fire
ci.Bus = ci.bus
return ci.bus