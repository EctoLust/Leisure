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


AddAction("BJ", "Suck off", function(act)
	if act.target and act.target:HasTag("bjable") and act.doer and act.doer:HasTag("bjable") then
        if act.target ~= act.doer then
		    return act.doer.components.bj:SuckOff(act.doer, act.target)
		elseif act.target == act.doer then
		    return act.doer.components.bj:Fap(act.doer)
		end
    end
end)

AddComponentAction( "SCENE", "bj", function(inst, doer, actions, right)
    if inst:HasTag("bjable") then
        table.insert(actions, GLOBAL.ACTIONS.BJ)
    end
end)

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES
local SpawnPrefab = GLOBAL.SpawnPrefab

local bj_trigger = GLOBAL.ActionHandler( GLOBAL.ACTIONS.BJ, "give")
AddStategraphActionHandler("wilson", bj_trigger)
AddStategraphActionHandler("wilson_client", bj_trigger)

GLOBAL.STRINGS["ACTIONS"]["BJ"] = {}
GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCK"] = "Suck off"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICK"] = "Lick pussy"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["FINGERSELF"] = "Finger self"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["FAP"] = "Fap"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["ROBOFAP"] = "Touch bolt" -- Wx78 fap (yes diffirent for fun, why not, fuck you.)
GLOBAL.STRINGS["ACTIONS"]["BJ"]["ROBOTEASE"] = "Tease socket" -- Wx78 fap female
GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCKBOLT"] = "Suck bolt" -- Wx78 blowjob
GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICKSOCKET"] = "Lick socket" -- Wx78 blowjob female


GLOBAL.ACTIONS.BJ.strfn = function(act) -- Strings for all actions.
    if act.target ~= nil then
        return 
		-- Robot
		(act.doer:HasTag("ROBOT") and act.target:HasTag("HaveDick") and act.target == act.doer and "ROBOFAP")
		or (act.doer:HasTag("ROBOT") and not act.target:HasTag("HaveDick") and act.target == act.doer and "ROBOTEASE")
		or (act.target:HasTag("ROBOT") and act.target:HasTag("HaveDick") and act.target ~= act.doer and "SUCKBOLT")
		or (act.target:HasTag("ROBOT") and not act.target:HasTag("HaveDick") and act.target ~= act.doer and "LICKSOCKET")
		-- Human
		or (not act.target:HasTag("HaveDick") and act.target ~= act.doer and "LICK")
		or (act.target:HasTag("HaveDick") and act.target ~= act.doer and "SUCK")
		or (not act.doer:HasTag("HaveDick") and act.target == act.doer and "FINGERSELF")
		or (act.doer:HasTag("HaveDick") and act.target == act.doer and "FAP")
		or nil
    end
end



