local afflictions = {}

function afflictions:new(con)
  con = con or {}
  local conv = {
    kelp = {"a piece of kelp", "an aurum flake"},
    bloodroot = {"a bloodroot leaf", "a magnesium chip"},
    ginseng = {"a ginseng root", "a ferrum flake"},
    pear = {"a piece of prickly pear", "a calcite mote"},
    goldenseal = {"a goldenseal root", "a plumbum flake"},
    elm = {"elm", "cinnabar"},
    lobelia = {"a lobelia seed", "an argentum flake"},
    ash = {"some prickly ash bark", "a stannum flake"},
    valerian = {"valerian", "realgar"},
    bellwort = {"a bellwort flower", "a cuprum flake"},
    ginger = {"a ginger root", "an antimony flake"}
  }
  con.eat = con.eat or false
  con.smoke = con.smoke or false
  con.apply = con.apply or false
  con.focus = con.focus or false
  con.cures = con.cures or {}
  if type(con.cures) == "string" then
    con.cures = conv[con.cures]
  end
  con.confidence = con.confidence or 0

  setmetatable(con, self)
  self.__index = self
  return con
end

function afflictions:get()
  self.confidence = 1
  raiseEvent("aff gained")
end

function afflictions:lose()
  self.confidence = 0
  raiseEvent("aff lost")
end

function afflictions:set(confidence)
  self.confidence = confidence
  raiseEvent("aff changed")
end

return afflictions