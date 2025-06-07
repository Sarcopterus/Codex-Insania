local ourClass = gmcp.Char.Status.class

if table.contains(fighter.classes.implemented, ourClass) then
    fighter.classes.implementations[ourClass].decideAction()
else
    cecho("\n<firebrick>COMBAT NOTICE: No implementation for " .. ourClass)
end
