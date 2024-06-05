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


AddAction("SEX", "Have sex with", function(act)
	if act.target and act.doer then
		if act.target:HasTag("sexable") or (act.target:HasTag("plantfuck") and act.doer:HasTag("plantkin")) then
			if act.target:HasTag("PLAYERALIKE") then
				return act.doer.components.sex:FuckCrabbyMommy(act.target, act.doer)
			end
			if not act.target:HasTag("MONSTER_PERVERT") and not act.target:HasTag("MONSTER_OBJECT") then
		        return act.doer.components.sex:Fuck(act.doer, act.target)
			elseif act.target:HasTag("MONSTER_PERVERT") then
			    return act.doer.components.sex:FriedlyMonsterFuck(act.doer, act.target)
			elseif act.target:HasTag("MONSTER_OBJECT") then
			    return act.doer.components.sex:FuckObject(act.doer, act.target)
			end
		elseif act.target:HasTag("flipfuckable") then
		    return act.doer.components.sex:FlipFuck(act.doer, act.target)
		end
    end
end)

AddComponentAction( "SCENE", "sex", function(inst, doer, actions, right)
    if inst:HasTag("sexable") or inst:HasTag("flipfuckable") or (inst:HasTag("plantfuck") and doer:HasTag("plantkin")) then
        table.insert(actions, GLOBAL.ACTIONS.SEX)
    end
end)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local sex_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.SEX, "give")
AddStategraphActionHandler("wilson", sex_trigger)
AddStategraphActionHandler("wilson_client", sex_trigger)

GLOBAL.STRINGS["ACTIONS"]["SEX"] = {}
GLOBAL.STRINGS["ACTIONS"]["SEX"]["FUCK"] = "Have sex with"
GLOBAL.STRINGS["ACTIONS"]["SEX"]["FLIPFUCK"] = "Have flipfuck with"

GLOBAL.ACTIONS.SEX.strfn = function(act) -- Strings for all actions.
    if act.target ~= nil then
        return (act.target:HasTag("sexable") and act.target ~= act.doer and "FUCK")
		or (act.target:HasTag("flipfuckable") and act.target ~= act.doer and "FLIPFUCK")
		or (act.target:HasTag("plantfuck") and act.target ~= act.doer and act.doer:HasTag("plantkin") and "FUCK")
		or nil
    end
end