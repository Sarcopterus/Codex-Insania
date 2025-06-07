-- The alchemist implementation variables
alchemist = alchemist or {}
alchemist.specialty = nil
alchemist.balances = alchemist.balances or {}
alchemist.balances.homunculus = true
alchemist.balances.humor = true
alchemist.humors = alchemist.humors or {}
alchemist.humors.table = {
    "Sanguine",
    "Sanguine",
    "Choleric",
    "Sanguine",
    "Melancholic",
    "Sanguine",
    "Phlegmatic"
}
alchemist.humors.index = 1
alchemist.wrackCount = 0
alchemist.inundate = false

-- The primary function to build pvp actions for the alchemist class
-- NOTE: This script was written for a Sublimation user and primarily pushes keeping class specific weaknesses and using bleeding/aurify as a killpath
function alchemist.decideAction()
    if gmcp.Char.Status.class ~= "Alchemist" then
        cecho("\n<firebrick>COMBAT NOTICE: Called Alchemist decision engine when not a Alchemist.")
        return
    end

    if not target or target == nil or target == "None" or target == "Dude" then
        cecho("\n<firebrick>COMBAT NOTICE: Called decision engine without a target.")
        return
    end

    -- set alchemist specialty if blank
    if gmcp.Char.Status.class == "Alchemist" and alchemist.specialty == nil then
        alchemist.setSpecialty()
    end

    local commandString = { "setalias murder stand" }
    local affsReport = {}
    local enemyClass = nil
    local humors = {
        Choleric = ak.alchemist.humour.choleric or 0,
        Melancholic = ak.alchemist.humour.melancholic or 0,
        Phlegmatic = ak.alchemist.humour.phlegmatic or 0,
        Sanguine = ak.alchemist.humour.sanguine or 0
    }

    if table.contains(Legacy.CT.Enemies, target) then
        enemyClass = Legacy.CT.Enemies[target]
    elseif table.contains(Legacy.NDB.db, target) then
        enemyClass = Legacy.NDB.db[target].class
    end

    -- Order: Homunculus Attack, Temper/Inundate, Educe/Wrack OR Truewrack <- That or a Killpath
    -- Killpath Reave: At least two tempered targets, can attempt to reave (not used)
    -- Killpath aurify: If HP/MP both < 60%, turn target to gold
    if (tonumber(ak.manapercent) < 60) and (tonumber(ak.healthpercent) < 60) then
        -- Unleash the Aurify!
        -- This one should process immediately
        table.insert(commandString, "aurify " .. target)
        send(table.concat(commandString, "/"))
        send("queue addclearfull eqbal murder")
        send("pt Starting Aurify attempt on " .. target)
        return
    end

    -- Homunculus - Homunculus Balance (Skip if not on balance)
    -- homunculus attack target (do damage) (3 seconds)
    -- homunculus shriek target (remove focus balance) (12 seconds) (unused)
    -- homunculus corrupt target (flips bleed/clot. Bleed now causes mana loss, and clotting causes damage) (12 seconds)
    if alchemist.balances.homunculus then
        local hpOver = tonumber(ak.healthpercent) > 60
        local mpOver = tonumber(ak.manapercent) > 60
        if (hpOver and not mpOver) or (mpOver and not hpOver) then
            -- One resource is high, the other is low. Corrupt to flip usage.
            table.insert(commandString, "homunculus corrupt " .. target)
            table.insert(affsReport, "homunculus corruption")
            alchemist.balances.homunculus = false
            tempTimer(12, function() alchemist.resetBalance("homunculus") end)
        else
            -- Just attack
            table.insert(commandString, "homunculus attack " .. target)
            alchemist.balances.homunculus = false
            tempTimer(3, function() alchemist.resetBalance("homunculus") end)
        end
    end

    -- Temper
    -- temper target humour (1.7 seconds Humor)
    -- inundate target humor (1.7 seconds humor)
    -- This will rotate through the alchemist.humors.table and temper those humors in order until it is time to inundate
    if humors.Sanguine > 2 then
        -- push inundate at 3+ sanguine to push bleeding
        table.insert(commandString, "inundate " .. target .. " sanguine")
        table.insert(affsReport, "bleeding")
        tempTimer(1.7, function() alchemist.resetBalance("humor") end)
        alchemist.inundate = true
    elseif humors.Phlegmatic >= 4 then
        -- For some reason, they allowed us to push phlegmatic very high so inundate this for extra affs
        table.insert(commandString, "inundate " .. target .. " phlegmatic")
        table.insert(affsReport, "lethargy")
        if humors.Phlegmatic >= 4 then table.insert(affsReport, "anorexia") end
        if humors.Phlegmatic >= 6 then table.insert(affsReport, "slickness") end
        if humors.Phlegmatic >= 8 then table.insert(affsReport, "weariness") end
        tempTimer(1.7, function() alchemist.resetBalance("humor") end)
    else
        -- Temper whatever humor we have
        local ourHumor = alchemist.humors.table[alchemist.humors.index]
        table.insert(commandString, "temper " .. target .. " " .. ourHumor)
        table.insert(affsReport, "tempered" .. ourHumor .. "(" .. tostring(humors[ourHumor] + 1) .. ")")
        alchemist.humors.index = alchemist.humors.index + 1
        if alchemist.humors.index > #alchemist.humors.table then alchemist.humors.index = 1 end
        tempTimer(1.7, function() alchemist.resetBalance("humor") end)
    end

    -- Educe
    local hpPercent = ((gmcp.Char.Vitals.hp / gmcp.Char.Vitals.maxhp) * 100)
    if alchemist.wrackCount ~= 0 and alchemist.wrackCount % 3 ~= 0 then
        -- Educe here as we aren't truewracking
        if ak.defs.shield then
            -- Break Shield
            table.insert(commandString, "educe copper " .. target)
        elseif alchemist.inundate then
            -- We inundated so we want to educe iron to push damage
            -- We should only not do that when the target is shielded
            table.insert(commandString, "educe iron" .. target)
            alchemist.inundate = false
        elseif hpPercent <= 40 then
            -- Educe tin to give us a break
            table.insert(commandString, "educe tin")
        else
            -- Just do damage
            table.insert(commandString, "educe iron " .. target)
        end
    end

    -- Wrack
    -- wrack target humor/affliction (2 seconds Bal)
    -- truewrack target humor/affliction humor/affliction (2.8 Seconds Bal)
    if alchemist.wrackCount ~= 0 and alchemist.wrackCount % 3 ~= 0 then
        -- Simple Wrack
        table.insert(commandString, "wrack " .. target .. " impatience")
        table.insert(affsReport, "impatience")
    else
        -- Truewrack
        local ourSecondAff = nil
        if table.contains(fighter.classes.clumsiness, enemyClass) then ourSecondAff = "clumsiness" end
        if table.contains(fighter.classes.weariness, enemyClass) then ourSecondAff = "weariness" end
        if table.contains(fighter.classes.stupidity, enemyClass) then ourSecondAff = "stupidity" end
        if table.contains(fighter.classes.haemophilia, enemyClass) then ourSecondAff = "haemophilia" end
        if ourSecondAff == nil then ourSecondAff = "haemophilia" end
        table.insert(commandString, "truewrack " .. target .. " impatience " .. ourSecondAff)
        table.insert(affsReport, "impatience")
        table.insert(affsReport, ourSecondAff)
    end
    alchemist.wrackCount = alchemist.wrackCount + 1

    -- Send final command, Report afflictions
    send(table.concat(commandString, "/"))
    send("queue addclearfull eqbal murder")
    send("pt " .. target .. " hit with " .. table.concat(affsReport, " "))

end

-- Functioned used to reset special class balances for Alchemist
function alchemist.resetBalance(which)
    if which == "homunculus" then
        alchemist.balances.homunculus = true
        cecho("\n<firebrick>COMBAT NOTICE: Homunculus balance restored.")
    elseif which == "humor" then
        alchemist.balances.humor = true
        cecho("\n<firebrick>COMBAT NOTICE: Humor balance restored.")
    else
        cecho("\n<firebrick>COMBAT NOTICE: We were asked to reset the Alchemist balance " .. which .. " but that isn't a valid balance.")
    end
end

-- A function that sets our alchemy specialty so we can refer to this much faster later
function alchemist.setSpecialty()
    local ourSpecialty = nil
    for k, v in pairs(gmcp.Char.Skills.Groups) do
        if v.name == "Sublimation" then
            ourSpecialty = "Sublimation"
            break
        end

        if v.name == "Formulation" then
            ourSpecialty = "Formulation"
            break
        end
    end

    if ourSpecialty == nil then
        cecho("\n<firebrick>COMBAT NOTICE: No alchemy specialty found. If you have not yet embraced your class or you are not currently an Alchemist this is normal. Otherwise, this is an error.")
    else
        alchemist.specialty = ourSpecialty
        cecho("\n<firebrick>COMBAT NOTICE: Set alchemy specialty to " .. ourSpecialty)
    end
end
