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

local handjob = false -- set it on true when handjob animation will be fully finished for female and male

AddAction("BJ", "Suck off", function(act)
	if act.target and act.target:HasTag("bjable") and act.doer and act.doer:HasTag("bjable") then
        if act.target ~= act.doer then
		    if handjob then
			    return act.doer.components.sex:HandjobNoCheck(act.doer, act.target)
			else
			    return act.doer.components.bj:SuckOff(act.doer, act.target)
			end
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
GLOBAL.STRINGS["ACTIONS"]["BJ"]["FINGERSELF"] = "Shlick"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["FAP"] = "Fap"
GLOBAL.STRINGS["ACTIONS"]["BJ"]["ROBOFAP"] = "Touch bolt" -- Wx78 fap (yes diffirent for fun, why not, fuck you.)
GLOBAL.STRINGS["ACTIONS"]["BJ"]["ROBOTEASE"] = "Tease socket" -- Wx78 fap female

if handjob then
    GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCK"] = "Handjob"
    GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICK"] = "Tease pussy"
	GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCKBOLT"] = "Nut bolt" -- Wx78
	GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICKSOCKET"] = "Tease socket" -- Wx78 female
else
    GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCK"] = "Suck off"
	GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICK"] = "Lick pussy"
	GLOBAL.STRINGS["ACTIONS"]["BJ"]["SUCKBOLT"] = "Suck bolt" -- Wx78 blowjob
	GLOBAL.STRINGS["ACTIONS"]["BJ"]["LICKSOCKET"] = "Lick socket" -- Wx78 blowjob female
end

local function HasDickTag(isnt)
    if isnt:HasTag("HaveDick") or isnt:HasTag("HaveDickDisquise") then
	    return true
	end
	return false
end

GLOBAL.ACTIONS.BJ.strfn = function(act) -- Strings for all actions.
    if act.target ~= nil then
        return 
		-- Robot
		(act.doer:HasTag("ROBOT") and HasDickTag(act.target) and act.target == act.doer and "ROBOFAP")
		or (act.doer:HasTag("ROBOT") and not HasDickTag(act.target) and act.target == act.doer and "ROBOTEASE")
		or (act.target:HasTag("ROBOT") and HasDickTag(act.target) and act.target ~= act.doer and "SUCKBOLT")
		or (act.target:HasTag("ROBOT") and not HasDickTag(act.target) and act.target ~= act.doer and "LICKSOCKET")
		-- Human
		or (not HasDickTag(act.target) and act.target ~= act.doer and "LICK")
		or (HasDickTag(act.target) and act.target ~= act.doer and "SUCK")
		or (not HasDickTag(act.doer) and act.target == act.doer and "FINGERSELF")
		or (HasDickTag(act.doer) and act.target == act.doer and "FAP")
		or nil
    end
end

GLOBAL.ACTIONS.BJ.rm = true -- Flags the right-click mapping for controllers

-- 1. SCENE ACTION (Allows controller auto-targeting to work on OTHER players)
AddComponentAction("SCENE", "bj", function(inst, doer, actions, right)
    if inst:HasTag("bjable") then
        table.insert(actions, GLOBAL.ACTIONS.BJ)
    end
end)

-- 2. TARGET OTHERS (Handles walking up to another player)
AddComponentPostInit("playercontroller", function(self)
    local old_GetRightClickAction = self.GetRightClickAction
    self.GetRightClickAction = function(self, target, position)
        if target and target:HasTag("bjable") and self.inst and self.inst:HasTag("bjable") then
            if target ~= self.inst then
                return GLOBAL.BufferedAction(self.inst, target, GLOBAL.ACTIONS.BJ)
            end
        end
        return old_GetRightClickAction(self, target, position)
    end
end)

-- 3. UNIQUE MOD NETWORK ROUTING TUNNEL
-- This registers an isolated data bridge between the client and server.
-- It bypasses standard game actions entirely, clearing 'GetPosition' and 'preview_cb' crashes!
AddModRPCHandler("LeisureFixedModNamespace", "TriggerSelfActionLoop", function(player)
    -- This code block runs natively on the HOST server backend
    if player and player:HasTag("bjable") and player.components.bj then
        player.components.bj:Fap(player)
    end
end)

-- 4. KEYBOARD BIND HOOK (Binds your unique network tunnel securely to the 'O' Key)
if GLOBAL.TheInput then
    GLOBAL.TheInput:AddKeyHandler(function(key, down)
        if key == GLOBAL.KEY_O and down then
            if GLOBAL.ThePlayer and GLOBAL.ThePlayer:HasTag("bjable") then
                if GLOBAL.TheFrontEnd and GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD" then
                    
                    -- A. CLIENT SIDE: Instantly trigger local character animation track
                    if GLOBAL.ThePlayer.sg then
                        local act = GLOBAL.BufferedAction(GLOBAL.ThePlayer, GLOBAL.ThePlayer, GLOBAL.ACTIONS.BJ)
                        GLOBAL.ThePlayer.sg:GoToState("give", act)
                    end
                    
                    -- B. SERVER SIDE: Send data message across our custom network bridge
                    if GLOBAL.TheNet:GetIsClient() then
                        local self_rpc_id = GLOBAL.GetModRPC("LeisureFixedModNamespace", "TriggerSelfActionLoop")
                        if self_rpc_id then
                            GLOBAL.SendModRPCToServer(self_rpc_id)
                        end
                    else
                        -- Host / Local offline fallback
                        if GLOBAL.ThePlayer.components.bj then
                            GLOBAL.ThePlayer.components.bj:Fap(GLOBAL.ThePlayer)
                        end
                    end
                    
                end
            end
        end
    end)
end

