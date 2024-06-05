local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local FOODTYPE = GLOBAL.FOODTYPE
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING
local TheSim = GLOBAL.TheSim
local Vector3 = GLOBAL.Vector3
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet


AddAction("SIMPLEUSE", "Use", function(act)
	if act.invobject and act.invobject.components.simpleuse then
        return act.invobject.components.simpleuse:Use(act.doer)
    end
end)

function SetupBottleDrinkActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.SIMPLEUSE)
end

AddComponentAction("INVENTORY", "simpleuse", SetupBottleDrinkActions)

local simpleuse_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.SIMPLEUSE, "dolongaction")
AddStategraphActionHandler("wilson", simpleuse_trigger)
AddStategraphActionHandler("wilson_client", simpleuse_trigger)
