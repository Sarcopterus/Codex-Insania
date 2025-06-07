local legacy = {}
legacy.Curing = {}
legacy.Curing.Stacks = {
  kelp = {"asthma","clumsiness","hypochondria","sensitivity","weariness","healthleech","parasite","rebbies"},
  ginseng = {"addiction","darkshade","haemophilia","lethargy","nausea","scytherus","flushings"},
  goldenseal = {"dizziness","epilepsy","impatience","shyness","stupidity","depression","shadowmadness","mycalium","sandfever","horror"},
  lobelia = {"agoraphobia","guilt","spiritburn","tenderskin","claustrophobia","loneliness","masochism","recklessness","vertigo"},
  ash = {"confusion","dementia","hallucinations","hypersomnia","paranoia"},
  bellwort = {"retribution","timeloop","peace","justice","lovers"},
}
legacy.Curing.Priorities = {
  Herbs = {"kelp","ginseng","goldenseal","lobelia","ash","bellwort"},
  Salves = {"mass","restore","mending","regeneration","soothing","epidermal"},
  Focus = {"impatience","stupidity","shyness","paranoia","hallucinations","mayhem","loneliness","hypersomnia"},
}
return legacy
