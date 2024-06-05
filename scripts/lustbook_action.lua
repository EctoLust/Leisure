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


AddAction("LUSTBOOK", "Read", function(act)
	if act.invobject and act.invobject.components.lustbook then
        return act.invobject.components.lustbook:Use(act.doer)
    end
end)

function SetupBottleDrinkActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.LUSTBOOK)
end

AddComponentAction("INVENTORY", "lustbook", SetupBottleDrinkActions)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local lustbook_action = GLOBAL.State{
        name = "lustbook_action",
        --tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:OverrideSymbol("lustbook", "lustbook_item", "lustbook")
			inst.components.locomotor:Stop()		
			inst.AnimState:PlayAnimation("lustbook", false)
        end,
		
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst:PerformBufferedAction()
                end
            end),
        },		

        onexit = function(inst)
		    inst.AnimState:ClearOverrideSymbol("lustbook")
        end,
}

local lustbook_action_client = GLOBAL.State{
        name = "lustbook_action",
        --tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:OverrideSymbol("lustbook", "lustbook_item", "lustbook")
			inst.components.locomotor:Stop()
		
			inst.AnimState:PlayAnimation("lustbook", false)
			inst:PerformPreviewBufferedAction()
        end,

        onexit = function(inst)
		    inst.AnimState:ClearOverrideSymbol("lustbook")
        end,
}

AddStategraphState("wilson", lustbook_action)
AddStategraphState("wilson_client", lustbook_action_client)

local lustbook_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.LUSTBOOK, "lustbook_action")
AddStategraphActionHandler("wilson", lustbook_trigger)
AddStategraphActionHandler("wilson_client", lustbook_trigger)