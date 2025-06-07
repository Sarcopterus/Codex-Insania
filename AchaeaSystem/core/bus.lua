-- simple pub/sub
ci.bus = { _l = {} }
function ci.bus.subscribe(evt,f)
  ci.bus._l[evt] = ci.bus._l[evt] or {}
  table.insert(ci.bus._l[evt], f)
end
function ci.bus.publish(evt,...)
  for _,fn in ipairs(ci.bus._l[evt] or {}) do fn(...) end
end
ci.Bus = ci.bus -- backwards compatibility
return ci.bus
