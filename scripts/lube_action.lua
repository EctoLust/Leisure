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


AddAction("LUBE", "Use", function(act)
	if act.invobject and act.invobject.components.lube then
        return act.invobject.components.lube:Use(act.doer)
    end
end)

function SetupBottleDrinkActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.LUBE)
end

AddComponentAction("INVENTORY", "lube", SetupBottleDrinkActions)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local lube_action = GLOBAL.State{
        name = "lube_action",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
		
			inst.AnimState:PlayAnimation("emote_pre_sit2")
		    inst.AnimState:PushAnimation("fap_loop_girl_new", false)
			inst.AnimState:PushAnimation("emote_pst_sit2", false)   
        end,
		
        timeline =
        {
            TimeEvent(17 * GLOBAL.FRAMES, function(inst)
                inst:PerformBufferedAction()
				inst.sg:RemoveStateTag("busy")
            end),
		},

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
        end,
}

local lube_action_client = GLOBAL.State{
        name = "lube_action",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
		
			inst.AnimState:PlayAnimation("emote_pre_sit2")
		    inst.AnimState:PushAnimation("fap_loop_girl_new", false)
			inst.AnimState:PushAnimation("emote_pst_sit2", false)
			inst:PerformPreviewBufferedAction()
        end,
		
        timeline =
        {
            TimeEvent(17 * GLOBAL.FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
            end),
		},

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
        end,
}

AddStategraphState("wilson", lube_action)
AddStategraphState("wilson_client", lube_action_client)

local lube_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.LUBE, "lube_action")
AddStategraphActionHandler("wilson", lube_trigger)
AddStategraphActionHandler("wilson_client", lube_trigger)

AddPrefabPostInit("glommerfuel",function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    inst:RemoveComponent("edible")
	inst:AddComponent("lube")
    inst.components.lube.lubecount = 15
end)
