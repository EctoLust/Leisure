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


AddAction("PLAYTOY", "Play", function(act)
	if act.invobject and act.invobject.components.playtoy then
	    if not act.invobject:HasTag("invsexable") then
		    return act.invobject.components.playtoy:Play(act.doer,act.invobject.intimswap)
		else
		    return act.invobject.components.playtoy:Fuck(act.doer,act.invobject)
		end
    end
end)
	
function SetupBottleDrinkActions(inst, doer, actions)
	table.insert(actions, GLOBAL.ACTIONS.PLAYTOY)
end

AddComponentAction("INVENTORY", "playtoy", SetupBottleDrinkActions)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local playtoy_ah = GLOBAL.ActionHandler( GLOBAL.ACTIONS.PLAYTOY, "give" )
AddStategraphActionHandler("wilson", playtoy_ah)
AddStategraphActionHandler("wilson_client", playtoy_ah)

GLOBAL.STRINGS["ACTIONS"]["PLAYTOY"] = {}
GLOBAL.STRINGS["ACTIONS"]["PLAYTOY"]["NORMAL"] = "Play"
GLOBAL.STRINGS["ACTIONS"]["PLAYTOY"]["FUCKIT"] = "Fuck"

GLOBAL.ACTIONS.PLAYTOY.strfn = function(act) -- Strings for all actions.
    if act.invobject ~= nil then
        return (not act.invobject:HasTag("invsexable") and "NORMAL")
		or (act.invobject:HasTag("invsexable") and "FUCKIT")
		or nil
    end
end




AddPrefabPostInit("trinket_5",function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("playtoy")
	inst.intimswap = "rocket"
end)
