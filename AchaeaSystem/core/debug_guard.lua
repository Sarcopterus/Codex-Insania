local yajl = yajl or require("yajl")
local function dbg(label, value)
  if type(value) == "table" then
    cecho(("<cyan>%s: %s\n"):format(label, yajl.to_string(value)))
  else
    cecho(("<cyan>%s: %s\n"):format(label, tostring(value)))
  end
end
_G.dbg = dbg
function display(...)
  error("\226\152\185 Don\226\128\153t display() tables in production.")
end
return dbg
