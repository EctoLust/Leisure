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

AddAction("SIMPLEREAD", "Read", function(act)
	if act.invobject and act.invobject.components.simpleread then
        return act.invobject.components.simpleread:Use(act.doer)
    end
end)

function SetupActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.SIMPLEREAD)
end

AddComponentAction("INVENTORY", "simpleread", SetupActions)

local simpleuse_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.SIMPLEREAD, "book")
AddStategraphActionHandler("wilson", simpleuse_trigger)
AddStategraphActionHandler("wilson_client", simpleuse_trigger)
