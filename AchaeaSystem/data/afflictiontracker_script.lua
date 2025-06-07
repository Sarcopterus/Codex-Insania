local aff = require("afflictions")
local tracker = {}

--[[
tracker.cures = {
  ash = "stannum",
  bayberry = "arsenic",
  bellwort = "cuprum",
  bloodroot = "magnesium",
  hawthorn = "calamine",
  ginger = "antimony",
  ginseng = "ferrum",
  goldenseal = "plumbum",
  kelp = "aurum",
  kola = "quartz",
  pear = "calcite",
} --]]


local affs = {}

affs.addiction = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.aeon = aff:new({
  smoke = true,
  cures = "elm",
})
affs.agoraphobia = aff:new({
  eat = true,
  focus = true,
  cures = "lobelia",
})
affs.anorexia = aff:new({
  focus = true,
  apply = true,
  cures = {"epidermal"}
})
affs.asthma = aff:new({
  eat = true,
  cures = "kelp"
})
affs.blistered = aff:new()
affs.bloodfire = aff:new()
affs.bound = aff:new()
affs.brokenleftarm = aff:new({
  apply = true,
  cures = {"mending"}
})
affs.brokenleftleg = aff:new({
  apply = true,
  cures = {"mending"},
})
affs.brokenrightarm = aff:new({
  apply = true,
  cures = {"mending"},
})
affs.brokenrightleg = aff:new({
  apply = true,
  cures = {"mending"},
})
affs.bruisedribs = aff:new()
affs.burning = aff:new({
  apply = true,
  cures = {"mending"},
})
affs.claustrophobia = aff:new({
  focus = true,
  eat = true,
  cures = "lobelia",
})
affs.clumsiness = aff:new({
  eat = true,
  cures = "kelp",
})
affs.coldfate = aff:new()
affs.concussion = aff:new({
  apply = true,
  cures = {"restoration to head"}
})
affs.conflagration = aff:new()
affs.confusion = aff:new({
  focus = true,
  eat = true,
  cures = "ash",
})
affs.corruption = aff:new()
affs.crackedribs = aff:new({
  cures = {"health to torso"},
})
affs.cremated = aff:new()
affs.crushedthroat = aff:new({
  apply = true,
  cures = {"mending to head"},
})
affs.damagedhead = aff:new({
  apply = true,
  cures = {"restoration to head"},
})
affs.damagedleftarm = aff:new({
  apply = true,
  cures = {"restoration to arms"},
})
affs.damagedleftleg = aff:new({
  apply = true,
  cures = {"restoration to legs"},
})
affs.damagedrightarm = aff:new({
  apply = true,
  cures = {"restoration to arms"},
})
affs.damagedrightleg = aff:new({
  apply = true,
  cures = {"restoration to legs"},
})
affs.darkshade = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.dazed = aff:new({
  smoke = true,
  cures = "elm",
})
affs.deadening = aff:new({
  smoke = true,
  cures = "elm",
})
affs.degenerate = aff:new()
affs.dehydrated = aff:new()
affs.dementia = aff:new({
  focus = true,
  eat = true,
  cures = "ash",
})
affs.demonstain = aff:new()
affs.depression = aff:new({
  eat = true,
  cures = "goldenseal",
})
affs.deteriorate = aff:new()
affs.disloyalty = aff:new({
  smoke = true,
  cures = "valerian",
})
affs.disrupted = aff:new()
affs.dissonance = aff:new({
  eat = true,
  cures = "goldenseal",
})
affs.dizziness = aff:new({
  focus = true,
  eat = true,
  cures = "goldenseal",
})
affs.enlightenment = aff:new()
affs.enmesh = aff:new()
affs.entangled = aff:new()
affs.entropy = aff:new()
affs.epilepsy = aff:new({
  focus = true,
  eat = true,
  cures = "goldenseal",
})
affs.flamefisted = aff:new()
affs.frozen = aff:new({
  apply = true,
  cures = {"caloric"}
})
affs.generosity = aff:new({
  focus = true, 
  eat = true, 
  cures = "bellwort",
})
affs.grievouswounds = aff:new({
  cures = {"apply health to torso"}
})
affs.guilt = aff:new({
  eat = true,
  cures = "lobelia",
})
affs.haemophilia = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.hallucinations = aff:new({
  focus = true,
  eat = true,
  cures = "ash",
})
affs.hamstrung = aff:new()
affs.hatred = aff:new()
affs.healthleech = aff:new({
  eat = true,
  cures = "kelp",
})
affs.hellsight = aff:new({
  smoke = true,
  cures = "valerian",
})
affs.hindered = aff:new()
affs.homunculusmercury = aff:new()
affs.hypersomnia = aff:new({
  eat = true,
  cures = "ash",
})
affs.hypochondria = aff:new({
  eat = true,
  cures = "kelp",
})
affs.hypothermia = aff:new({
  apply = true,
  cures = {"restoration to torso"}
})
affs.icefisted = aff:new()
affs.impaled = aff:new()
affs.impatience = aff:new({
  eat = true,
  cures = "goldenseal",
})
affs.indifference = aff:new({
  eat = true,
  cures = "bellwort",
})
affs.inquisition = aff:new()
affs.internalbleeding = aff:new()
affs.isolation = aff:new()
affs.itching = aff:new({
  apply = true,
  cures = {"epidermal to body"}
})
affs.justice = aff:new({
  eat = true,
  cures = "bellwort",
})
affs.kaisurge = aff:new()
affs.kkractclebrand = aff:new({
  cures = {"sip health"}
})
affs.laceratedthroat = aff:new({
  apply = true,
  cures = {"restoration to head"},
})
affs.lapsingconsciousness = aff:new()
affs.latched = aff:new({
  cures = {"sip health"}
})
affs.lethargy = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.lightbind = aff:new()
affs.loneliness = aff:new({
  focus = true,
  eat = true,
  cures = "goldenseal",
})
affs.lovers = aff:new({
  focus = true,
  eat = true,
  cures = "lobelia"
})
affs.manaleech = aff:new({
  smoke = true,
  cures = "valerian",
})
affs.mangledhead = aff:new({
  apply = true,
  cures = {"restoration to head"},
})
affs.mangledleftarm = aff:new({
  apply = true,
  cures = {"restoration to arms"},
})
affs.mangledleftleg = aff:new({
  apply = true,
  cures = {"restoration to legs"},
})
affs.mangledrightarm = aff:new({
  apply = true,
  cures = {"restoration to arms"},
})
affs.mangledrightleg = aff:new({
  apply = true,
  cures = {"restoration to legs"},
})
affs.masochism = aff:new({
  focus = true,
  eat = true,
  cures = "lobelia",
})
affs.mildtrauma = aff:new({
  apply = true,
  cures = {"restoration to torso"}
})
affs.mindclamp = aff:new()
affs.mindravaged = aff:new()
affs.muddled = aff:new()
affs.nausea = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.numbedleftarm = aff:new()
affs.numbedrightarm = aff:new()
affs.pacified = aff:new({
  focus = true,
  eat = true,
  cures = "bellwort",
})
affs.palpatarfeed = aff:new()
affs.paralysis = aff:new({
    eat = true,
    cures = "bloodroot",
})
affs.paranoia = aff:new({
  focus = true,
  eat = true,
  cures = "ash",
})
affs.parasite = aff:new({
  eat = true,
  cures = "kelp",
})
affs.peace = aff:new({
  focus = true,
  eat = true,
  cures = "bellwort",
})
affs.penitence = aff:new()
affs.petrified = aff:new()
affs.phlogisticated = aff:new()
affs.pinshot = aff:new()
affs.pressure = aff:new({
  eat = true,
  cures = "pear",
})
affs.prone = aff:new()
affs.recklessness = aff:new({
  focus = true,
  eat = true,
  cures = "lobelia",
})
affs.retribution = aff:new({
  focus = true,
  eat = true,
  cures = {"retribution"}
})
affs.revealed = aff:new()
affs.scalded = aff:new({
  apply = true,
  cures = {"epidermal to head"}
})
affs.scrambledbrains = aff:new()
affs.scytherus = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.selarnia = aff:new({
  apply = true,
  cures = {"mending to body"},
})
affs.sensitivity = aff:new({
  eat = true,
  cures = "kelp",
})
-- override sensi to cure deafness first
function affs.sensitivity:get(defs)
  if defs.deafness then
    defs.deafness = false
  else
    self.confidence = 1
    raiseEvent("aff gained")
  end
end

affs.serioustrauma = aff:new({
  apply = true,
  cures = "restoration to torso",
})
affs.shadowmadness = aff:new({
  eat = true,
  cures = {"shadowmadness", "3p"},
})
affs.shivering = aff:new({
  apply = true,
  cures = {"caloric to body"},
})
affs.shyness = aff:new({
  focus = true,
  eat = true,
  cures = "goldenseal",
})
affs.silenced = aff:new()
affs.silver = aff:new()
affs.skullfractures = aff:new({
  cures = {"apply health to head"},
})
affs.slashedthroat = aff:new({
  apply = true,
  cures = {"epidermal to head"}
})
affs.sleeping = aff:new()
affs.slickness = aff:new({
  smoke = true,
  eat = true,
  cures = {"a bloodroot leaf", "a magnesium flake", "valerian", "realgar"}
})
affs.slimeobscure = aff:new()
affs.solarburn = aff:new()
affs.spiritburn = aff:new({
  eat = true,
  cures = "lobelia",
})
affs.stupidity = aff:new({
  focus = true,
  eat = true,
  cures = "goldenseal",
})
affs.stuttering = aff:new({
  apply = true, 
  focus = true,
  cures = {"epidermal"}
})
affs.temperedcholeric = aff:new({
  eat = true,
  cures = "ginger"
})
affs.temperedmelancholic = aff:new({
  eat = true,
  cures = "ginger"
})
affs.temperedphlegmatic = aff:new({
  eat = true,
  cures = "ginger"
})
affs.temperedsanguine = aff:new({
  eat = true,
  cures = "ginger"
})
affs.tenderskin = aff:new({
  eat = true,
  cures = "lobelia",
})
affs.tension = aff:new({
  eat = true,
  cures = {"tension"}
})
affs.timeflux = aff:new()
affs.timeloop = aff:new({
  eat = true,
  cures = {"timeloop"}
})
affs.tonguetied = aff:new({
  apply = true,
  cures = {"restoration to head"}
})
affs.torntendons = aff:new({
  cures = {"apply health to legs"}
})
affs.transfixation = aff:new()
affs.trueblind = aff:new()
affs.unconsciousness = aff:new()
affs.unweavingbody = aff:new({
  eat = true,
  cures = "ginseng",
})
affs.unweavingmind = aff:new({
  eat = true,
  cures = "goldenseal",
})
affs.unweavingspirit = aff:new({
  smoke = true,
  cures = "elm"
})
affs.vertigo = aff:new({
  focus = true,
  eat = true,
  cures = "lobelia",
})
affs.vinewreathed = aff:new()
affs.vitiated = aff:new()
affs.vitrified = aff:new()
affs.voidfisted = aff:new()
affs.voyria = aff:new()
affs.waterbonds = aff:new()
affs.weakenedmind = aff:new()
affs.weariness = aff:new({
  eat = true,
  cures = "kelp",
})
affs.webbed = aff:new()
affs.whisperingmadness = aff:new({
  eat = true,
  cures = {"whisperingmadness", "3p"}
})
affs.wristfractures = aff:new({
  cures = {"apply health to arms"}
}) 

function tracker:new(con)
  con = con or {}

  con.class = con.class or "None"
  con.cures = con.cures or {}
  con.cures.kelp = con.cures.kelp or "kelp"
  con.cures.bloodroot = con.cures.bloodroot or "bloodroot"
  con.cures.ginseng = con.cures.ginseng or "ginseng"
  con.cures.goldenseal = con.cures.goldenseal or "goldenseal"
  con.cures.ash = con.cures.ash or "ash"
  con.cures.bellwort = con.cures.bellwort or "bellwort"
  con.cures.pear = con.cures.pear or "pear"

  con.defences = con.defences or {}
  con.defences.blindness = con.defences.blindness or true
  con.defences.deafness = con.defences.deafness or true
  con.defences.speed = con.defences.speed or true
  con.defences.rebounding = con.defences.rebounding or true
  con.defences.shield = con.defences.shield or true

  con.afflictions = con.afflictions or table.deepcopy(affs)

  setmetatable(con, self)
  self.__index = self
  return con
end

function tracker:cure(map)
  local t = {}
  local s = self
  local a = s.afflictions
  local d = s.defences

  for name, affliction in pairs(a) do
    if map(affliction) and affliction.confidence > 0 then
      table.insert(t, name)
    end
  end
  if #t == 0 then return end
  local change = 1/#t
  for _, affliction in pairs(t) do
    a[affliction].confidence = a[affliction].confidence - change
  end
  
  self:cleanup()
  raiseEvent("tracker cure")
end

function tracker:cleanup()
  for name, affliction in pairs(self.afflictions) do
    if affliction.confidence < 0.25 then affliction.confidence = 0 end
  end
end

function tracker:reset()
  for name, aff in pairs(self.afflictions) do
    aff.confidence = 0
  end
  raiseEvent("tracker cure")
end

return tracker