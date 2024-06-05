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


AddAction("TIE", "Tie", function(act)
	if act.invobject and act.invobject.components.tie then
        return act.invobject.components.tie:Tie(act.doer)
    end
end)

function SetupBottleDrinkActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.TIE)
end

AddComponentAction("INVENTORY", "tie", SetupBottleDrinkActions)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local tie_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.TIE, "bundle")
AddStategraphActionHandler("wilson", tie_trigger)
AddStategraphActionHandler("wilson_client", tie_trigger)

AddPrefabPostInit("rope",function(inst)
    inst:AddTag("tieer")
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("tie")
end)
