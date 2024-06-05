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


AddAction("PUTON", "Wear", function(act)
	if act.invobject and act.invobject.components.puton then
        return act.invobject.components.puton:PutOn(act.doer)
    end
end)

function SetupActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.PUTON)
end

AddComponentAction("INVENTORY", "puton", SetupActions)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local puton_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.PUTON, "dolongaction")
AddStategraphActionHandler("wilson", puton_trigger)
AddStategraphActionHandler("wilson_client", puton_trigger)