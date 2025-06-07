-- Psion Implementation Variables
psion = psion or {}
psion.timeToFlurry = false

-- The primary function to build pvp actions for the psion class
-- NOTE: This script primarily pushes for keeping specific class weaknesses applied and stacking unweaved body/mind until it can be inverted to spirit and flurried against
function psion.decideAction()
    if gmcp.Char.Status.class ~= "Psion" then
        cecho("\n<firebrick>COMBAT NOTICE: Called Psion decision engine when not a Psion.")
        return
    end

    if not target or target == nil or target == "None" or target == "Dude" then
        cecho("\n<firebrick>COMBAT NOTICE: Called decision engine without a target.")
        return
    end

    local commandString = { "setalias murder stand" }
    local affsReport = {}
    local limbs = nil
    local enemyClass = nil
    local unwoven = {}
    local psionFlags = {}
    local preferredLeg = nil
    local preferredArm = nil

    -- Preset flags
    psionFlags.clumsiness = false
    psionFlags.weariness = false
    psionFlags.stupidity = false

    -- Check enemy class
    if table.contains(Legacy.CT.Enemies, target) then
        enemyClass = Legacy.CT.Enemies[target]
    elseif table.contains(Legacy.NDB.db, target) then
        enemyClass = Legacy.NDB.db[target].class
    end

    -- check limb damage
    if table.contains(lb, target) then limbs = lb[target] end

    -- Set preferred limbs
    if limbs ~= nil then
        local limbTable = { "right", "left" }

        if limbs.hits['left leg'] > limbs.hits['right leg'] then
            preferredLeg = 'left'
        elseif limbs.hits['left leg'] == limbs.hits['right leg'] then
            preferredLeg = limbTable[math.random(#limbTable)]
        else
            preferredLeg = 'right'
        end

        if limbs.hits['left arm'] > limbs.hits['right arm'] then
            preferredArm = 'left'
        elseif limbs.hits['left arm'] == limbs.hits['right arm'] then
            preferredArm = limbTable[math.random(#limbTable)]
        else
            preferredArm = 'right'
        end
    end

    -- Set unweavings
    if table.contains(ak.psion.unweaving, 'body') then unwoven.body = ak.psion.unweaving.body else unwoven.body = 0 end
    if table.contains(ak.psion.unweaving, 'mind') then unwoven.mind = ak.psion.unweaving.mind else unwoven.mind = 0 end
    if table.contains(ak.psion.unweaving, 'spirit') then unwoven.spirit = ak.psion.unweaving.spirit else unwoven.spirit = 0 end

    -- Weave Prepare
    -- Disruption = paralysis
    -- Laceration = haemophilia
    -- Dazzle = clumsiness
    -- Rattle = epilepsy
    -- Vapours = asthma
    -- Incisive = beats clumsiness
    -- Order: Incisive for Clumsiness, Paralysis, Class Specific, Asthma, Haemophilia, Epilepsy, Clumsy
    if Legacy.Curing.Affs['clumsiness'] then
        -- We have clumsiness so use incisive
        table.insert(commandString, "weave prepare incisive")
    elseif not ak.check('paralysis', 100) then
        table.insert(commandString, "weave prepare disruption")
        table.insert(affsReport, "paralysis")
    elseif enemyClass ~= nil and table.contains(fighter.classes.clumsiness, enemyClass) and not ak.check('clumsiness', 100) then
        table.insert(commandString, "weave prepare dazzle")
        table.insert(affsReport, "clumsiness")
        psionFlags.clumsiness = true
    elseif enemyClass ~= nil and table.contains(fighter.classes.haemophilia, enemyClass) and not ak.check('haemophilia', 100) then
        table.insert(commandString, "weave prepare laceration")
        table.insert(affsReport, "haemophilia")
    elseif not ak.check('asthma', 100) then
        table.insert(commandString, "weave prepare vapours")
        table.insert(affsReport, "asthma")
    elseif not ak.check('haemophilia', 100) then
        table.insert(commandString, "weave prepare laceration")
        table.insert(affsReport, "haemophilia")
    elseif not ak.check('epilepsy', 100) then
        table.insert(commandString, "weave prepare rattle")
        table.insert(affsReport, "epilepsy")
    elseif not ak.check('clumsiness', 100) then
        table.insert(commandString, "weave prepare dazzle")
        table.insert(affsReport, "clumsiness")
        psionFlags.clumsiness = true
    end

    -- We do not have transcend, but once we do decide psionics action here
    -- examples:
    -- If paralized, we can psi manipulate touch tree
    -- we can excise if mana less than 30% on enemy
    -- we can use psi splinter to break shields
    -- we can use psi combustion to push bleeding
    -- we can use psi expunge to cure impatience
    -- we can use psi muddle on stupidity inflicted enemies
    -- we can just straight up psi shatter them

    -- Weaving
    if ak.defs.shield then
        table.insert(commandString, "weave cleave " .. target)
    elseif unwoven.mind == 0 then
        table.insert(commandString, "weave unweave " .. target .. " mind")
        table.insert(affsReport, "unweavingmind(1)")
    elseif unwoven.body == 0 then
        table.insert(commandString, "weave unweave " .. target .. " body")
        table.insert(affsReport, "unweavingbody(1)")
    elseif not psionFlags.clumsiness and enemyClass ~= nil and table.contains(fighter.classes.clumsiness, enemyClass) and not ak.check("clumsiness", 100) then
        table.insert(commandString, "weave sever " .. target .. " " .. preferredArm)
        table.insert(affsReport, "clumsiness")
        psionFlags.clumsiness = true
    elseif not psionFlags.weariness and enemyClass ~= nil and table.contains(fighter.classes.weariness, enemyClass) and not ak.check("weariness", 100) then
        table.insert(commandString, "weave puncture " .. target .. " " .. preferredArm)
        table.insert(affsReport, "weariness")
        psionFlags.weariness = true
    elseif not psionFlags.stupidity and enemyClass ~= nil and table.contains(fighter.classes.stupidity, enemyClass) and not ak.check("stupidity", 100) then
        table.insert(commandString, "weave backhand " .. target)
        table.insert(affsReport, "stupidity")
        table.insert(affsReport, "dizziness")
        psionFlags.stupidity = true
    elseif not ak.check("nausea", 100) then
        -- exsanguinate for nausea
        table.insert(commandString, "weave exsanguinate " .. target)
        table.insert(affsReport, "nausea")
        if ak.bleeding >= 150 then table.insert(affsReport, "anorexia") end
    elseif not ak.check("asthma", 100) then
        -- deathblow for asthma
        table.insert(commandString, "weave deathblow " .. target)
        table.insert(affsReport, "asthma")
        table.insert(affsReport, "bleeding")
    elseif not ak.check("stupidity", 100) or not ak.check("dizziness", 100) then
        -- backhand for stupidity and dizziness
        table.insert(commandString, "weave backhand " .. target)
        table.insert(affsReport, "stupidity")
        table.insert(affsReport, "dizziness")
        psionFlags.stupidity = true
    elseif not ak.check("blackout", 100) and ak.check("prone", 100) then
        -- lightsteal for blackout
        table.insert(commandString, "weave lightsteal " .. target)
        table.insert(affsReport, "trueblind")
        table.insert(affsReport, "blackout")
    elseif unwoven.body == 5 then
        -- invert!
        table.insert(commandString, "weave invert " .. target .. " body spirit")
        table.insert(affsReport, "unweavingspirit(5)")
        psion.timeToFlurry = true
    elseif unwoven.mind == 5 then
        -- invert!
        table.insert(commandString, "weave invert " .. target .. " mind spirit")
        table.insert(affsReport, "unweavingspirit(5)")
        psion.timeToFlurry = true
    elseif psion.timeToFlurry then
        -- Unleash Flurry!
        table.insert(commandString, "weave flurry " .. target)
        psion.timeToFlurry = false
    elseif unwoven.body < 5 then
        table.insert(commandString, "weave unweave " .. target .. " body")
        table.insert(affsReport, "unweavingbody(" .. tostring(unwoven.body + 1) .. ")")
    elseif unwoven.mind < 5 then
        table.insert(commandString, "weave unweave " .. target .. " mind")
        table.insert(affsReport, "unweavingmind(" .. tostring(unwoven.mind + 1) .. ")")
    end

    -- Send final command, Report afflictions
    send(table.concat(commandString, "/"))
    send("queue addclearfull eqbal murder")
    send("pt " .. target .. " hit with " .. table.concat(affsReport, " "))

    -- If we are automating, start automation
    if fighter.automate then
        psion.pid = registerAnonymousEventHandler("gmcp.Char.Vitals", "psion.isReady")
    end
end
