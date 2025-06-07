fighter = fighter or {}

function fighter.Setup()
    fighter.classes = {}
    
    -- To add a new class, put the name here
    fighter.classes.implemented = {
        "Psion",
        "Alchemist"
    }

    -- Then in here,  set the class name from above equal to the main object in that classes pvp script
    fighter.classes.implementations = {
        Psion = psion,
        Alchemist = alchemist
    }

    -- Classes where we want to push stupidity
    fighter.classes.stupidity = {
        "Alchemist"
    }

    -- Classes where we want to push clumsiness
    fighter.classes.clumsiness = {
        "Blademaster",
        "Druid",
        "Infernal",
        "Monk",
        "Paladin",
        "Runewarden",
        "Priest",
        "Sentinel",
        "Serpent",
        "Shaman",
        "Psion",
        "Depthswalker"
    }

    -- classes where we want to push weariness
    fighter.classes.weariness = {
        "Blademaster",
        "Druid",
        "Monk",
        "Priest",
        "Pariah",
        "Occultist",
        "Sentinel",
        "Serpent"
    }

    -- classes where we want to push confusion
    fighter.classes.confusion = {
        "Psion"
    }

    -- classes where we want to push haemophilia
    fighter.classes.haemophilia = {
        "Magi"
    }

    -- Here is an example of adding additional setup for your pvp systems
    -- This will set the variable alchemist.specialty to Sublimation or Formulation depending
    alchemist.setSpecialty()
end
registerAnonymousEventHandler("sysLoadEvent", "fighter.Setup")

function fighter.verifyInstall(_, name)
    if name ~= "Fighter" then return end
    fighter.Setup()
end
registerAnonymousEventHandler("sysInstall", "fighter.verifyInstall")

function fighter.verifyUninstall(_, name)
    if name ~= "Fighter" then return end
    fighter = nil
    alchemist = nil
    psion = nil
end
registerAnonymousEventHandler("sysUninstall", "fighter.verifyUninstall")

function fighter.generateHelp()
    local tablemaker = require("Fighter.MDK.ftext").TableMaker
    local formatter = require ("Fighter.MDK.ftext").TextFormatter

    headerFormat = formatter:new({
        width = 80,
        cap = "<|",
        capColor = "<DarkSlateBlue>",
        textColor = "<white>",
        spacerColor = "<steel_blue>",
        inside = false,
        spacer = " ",
        alignment = "center",
        mirror = true
    })

    helpTable = tablemaker:new({
        title = "Fighter Help",
        printTitle = false,
        printHeaders = true,
        frameColor = "<steel_blue>",
        separateRows = false,
        forceHeaderSeparator = true
    })
    helpTable:addColumn({
        name = "Command",
        width = 30,
        textColor = "<DarkSlateBlue>"
    })
    helpTable:addColumn({
        name = "Description",
        width = 50,
        textColor = "<DarkSlateGrey>"
    })
    --fight
    helpTable:addRow({
        "fight",
        "Generate your next pvp action."
    })
    --fighthelp
    helpTable:addRow({
        "<LightSlateBlue>fighthelp",
        "<LightSlateGrey>Display this menu."
    })
    --fightreset
    helpTable:addRow({
        "fightreset",
        "Reload the Fighter Engine to pickup changes."
    })

    cecho(headerFormat:format("Fighter Help Docs"))
    cecho(helpTable:assemble())

end