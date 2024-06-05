local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local State = GLOBAL.State
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local ACTIONS = GLOBAL.ACTIONS
local FRAMES = GLOBAL.FRAMES

local suck_state = State{
        name = "suck_state",
        tags = { "suck", "nopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
			    inst.components.inventory:DropItem(hands_item)
			end
			inst.AnimState:PlayAnimation("girl_pre")
			inst.AnimState:PushAnimation("girl_loop", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopbj")
        end,
    }
	
local lick_state = State{
        name = "lick_state",
        tags = { "suck", "nopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
			    inst.components.inventory:DropItem(hands_item)
			end
			inst.AnimState:PlayAnimation("girl_pre")
			inst.AnimState:PushAnimation("girl_lick", true)
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
            inst:PushEvent("stopbj")
        end,
    }
	
local suckenjoy_state = State{
        name = "suckenjoy_state",
        tags = { "suck", "cancum", "nopredict", "cancumonface"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
			    inst.components.inventory:DropItem(hands_item)
			end 
			inst.AnimState:PlayAnimation("body_pre")
			inst.AnimState:PushAnimation("body_loop", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
            inst:PushEvent("stopbj")
        end,
    }

local fap_state = State{
        name = "fap_state",
        tags = { "fap", "cancum", "nopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			if inst.components.naked.havedick == false then
			    inst.AnimState:PlayAnimation("emote_pre_sit2")
			    inst.AnimState:PushAnimation("fap_loop_girl_new_new", true)
			else
			    inst.AnimState:PlayAnimation("emote_pre_sit2")
			    inst.AnimState:PushAnimation("fap_loop_new_new", true)
			end
			
			--inst.AnimState:PushAnimation("titsplay", true)
			--inst.AnimState:OverrideSymbol("tit_r", "willow_nude", "tit_r")
			--inst.AnimState:OverrideSymbol("tit_l", "willow_nude", "tit_l")
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
        end,
    }
	
local plush_toy = State{
        name = "plush_toy",
        tags = { "toy", "fap", "cancum", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			if inst.intim_gender == "FEMALE" then
			    inst.AnimState:PlayAnimation("emote_pre_sit2")
				inst.AnimState:PushAnimation("fuck_toy_girl_finger", true)
			else
			    inst.AnimState:PlayAnimation("emote_pre_sit2")
			    inst.AnimState:PushAnimation("fuck_toy", true)
			end
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
        end,
    }
	
local dilding = State{
        name = "dilding",
        tags = { "toy", "fap", "cancum", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			inst.AnimState:PlayAnimation("emote_pre_sit2")
		    inst.AnimState:PushAnimation("dilding", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
		    inst.AnimState:ClearOverrideSymbol("dick_other")
        end,
    }
	
local vibrating = State{
        name = "vibrating",
        tags = { "toy", "fap", "cancum", "nopredict", "noslic"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			inst.AnimState:PlayAnimation("emote_pre_sit2")
		    inst.AnimState:PushAnimation("vibrating", true)
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_idle_LP", "vibrator", 0.24)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
		    inst.AnimState:ClearOverrideSymbol("dick_other")
			inst.SoundEmitter:KillSound("vibrator")
        end,
    }
	
local rocketfuck = State{
        name = "rocketfuck",
        tags = { "toy", "fap", "cancum", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
		    inst.AnimState:PushAnimation("rocketfuck", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
		    inst.AnimState:ClearOverrideSymbol("rocket")
        end,
    }
	
	
local layfuck_state = State{
        name = "layfuck_state",
        tags = { "fuck", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			inst.AnimState:PlayAnimation("sex_bottom", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)		    
			inst:PushEvent("stopfuck")
        end,
    }
	
local riderfuck_state = State{
        name = "riderfuck_state",
        tags = { "fuck", "cancum", "nopredict", "cancumonbody"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end

			local fuckmode = inst.components.naked:CheckSexGender()	
            inst.components.naked:AnimWithTits(true)			
			
			if fuckmode == "iam" or fuckmode == "gay" then		
			    inst.AnimState:PlayAnimation("sex_ride", true)
			else
			    inst.AnimState:PlayAnimation("sex_ride_girl", true)
			end			
			
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
			inst.components.naked:AnimWithTits(false)
        end,
    }
	
local ropped_state = State{
        name = "ropped_state",
		tags = {"busy", "knockout", "nopredict", "nomorph"},
        --tags = {"ropped_state"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("ropped_idle", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
        end,
    }
	
local roppedfuck_state = State{
        name = "roppedfuck_state",
        tags = {"fuck", "busy", "nopredict", "nomorph", "cancumonface"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			--inst.AnimState:PlayAnimation("ropped_sex_bottom", true)
			inst.AnimState:PlayAnimation("sex_bottom", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
        end,
    }
	
local flipfuck_girl = State{
        name = "flipfuck_girl",
        tags = {"fuck", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
            local fuckmode = inst.components.naked:CheckSexGender()	
			
			if fuckmode == "iam" then
			    inst.AnimState:PlayAnimation("flipfuck_girl_v3", true) -- Laying without dick
			else
			    inst.AnimState:PlayAnimation("flipfuck_girl", true) -- Laying drilled in ass
			end		
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
        end,
    }
local flipfuck = State{
        name = "flipfuck",
        tags = {"fuck", "cancum", "nopredict", "cancumonbody"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			local fuckmode = inst.components.naked:CheckSexGender()
            inst.components.naked:AnimWithTits(true)			
			
			if fuckmode ~= "lesbian" and fuckmode ~= "partner" then
			    inst.AnimState:PlayAnimation("flipfuck", true) -- Penetrate with dick
			else
			    if fuckmode == "lesbian" then
			        inst.AnimState:PlayAnimation("flipfuck_old", true) -- Rub
				elseif fuckmode == "partner" then
				    inst.AnimState:PlayAnimation("flipfuck_v2", true) -- Jump on dick
				end
			end
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
			inst.components.naked:AnimWithTits(false)
        end,
    }

local fuck_spider = State{
        name = "fuck_spider",
        tags = {"fuck","toy", "cancum", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			inst.AnimState:PlayAnimation("player_fuck_spider", true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("killtoy")
        end,
    }
local puton_body = State{
        name = "puton_body",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_strikepose", false)
        end,

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
local puton_legs = State{
        name = "puton_legs",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_pants", false)
        end,

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
local puton_feet = State{
        name = "puton_feet",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_feet", false)
        end,

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
local puton_hand = State{
        name = "puton_hand",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("emote_hands", false)
        end,

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
local takeoff_legs = State{
        name = "takeoff_legs",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("takeoff_legs", false)
        end,
		
        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
                 if inst.components.naked then
				     inst.components.naked:TakeOffClothing("legs")
				 end
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
local takeoff_body = State{
        name = "takeoff_body",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("takeoff_body", false)
        end,
		
        timeline =
        {
            TimeEvent(19 * FRAMES, function(inst)
                 if inst.components.naked then
				     inst.components.naked:TakeOffClothing("body")
				 end
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
local takeoff_feet = State{
        name = "takeoff_feet",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("pickup")
            
        end,
		
        timeline =
        {
            TimeEvent(17 * FRAMES, function(inst)
                 if inst.components.naked then
				     
				 end
            end),
		},

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then             
					if inst.AnimState:IsCurrentAnimation("pickup") then
					    inst.components.naked:TakeOffClothing("feet")
						inst.AnimState:PlayAnimation("pickup_pst")				
					elseif inst.AnimState:IsCurrentAnimation("pickup_pst") then
					    inst.sg:GoToState("idle")
					end
                end
            end),
        },

        onexit = function(inst)
        end,
    }
	
local takeoff_all = State{
        name = "takeoff_all",
		tags = {"busy", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
            if inst.components.naked then
				inst.components.naked:TakeOffClothing("hand")
		    end			
			inst.AnimState:PlayAnimation("takeoff_body", false)
			inst.AnimState:PushAnimation("takeoff_legs", false)
			inst.AnimState:PushAnimation("pickup", false)			
        end,
		
        timeline =
        {
            TimeEvent(21 * FRAMES, function(inst)
                 if inst.components.naked then
				     inst.components.naked:TakeOffClothing("body")
				 end
            end),
            TimeEvent(42 * FRAMES, function(inst)
                 if inst.components.naked then
				     inst.components.naked:TakeOffClothing("legs")
				 end
            end),
		},

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then             
					if inst.AnimState:IsCurrentAnimation("pickup") then
					    inst.components.naked:TakeOffClothing("feet")
						inst.components.naked:TakeOffClothing("stockings")
						inst.AnimState:PlayAnimation("pickup_pst")				
					elseif inst.AnimState:IsCurrentAnimation("pickup_pst") then
					    inst.sg:GoToState("idle")
					end
                end
            end),
        },

        onexit = function(inst)
        end,
    }
	
local kness = State{
        name = "kness",
        tags = {"fuck", "cancum", "nopredict", "cancumonface"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
		
			local fuckmode = inst.components.naked:CheckSexGender()		
			
			if fuckmode == "lesbian" or fuckmode == "partner" then			
			    inst.AnimState:PlayAnimation("kness_lez", true)
			else
			    inst.AnimState:PlayAnimation("kness", true)
			end
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
        end,
    }
	
local kness_girl = State{
        name = "kness_girl",
        tags = {"fuck", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			local fuckmode = inst.components.naked:CheckSexGender()		
			
			if fuckmode == "lesbian" or fuckmode == "iam" then		
			    inst.AnimState:PlayAnimation("kness_girl_lez", true)
			else
			    inst.AnimState:PlayAnimation("kness_girl", true)
			end
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
        end,
    }
	
local doggy = State{
        name = "doggy",
        tags = {"fuck", "cancum", "nopredict", "cancumonbody"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
		
			local fuckmode = inst.components.naked:CheckSexGender()		
			inst.components.naked:AnimWithTits(true)
			
			if fuckmode == "lesbian" or fuckmode == "partner" then			
			    inst.AnimState:PlayAnimation("doggy_lez", true)
			else
			    inst.AnimState:PlayAnimation("doggy", true)
			end
			
			
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopfuck")
			inst.components.naked:AnimWithTits(false)
        end,
    }
	
local doggy_girl = State{
        name = "doggy_girl",
        tags = {"fuck", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
		
			local fuckmode = inst.components.naked:CheckSexGender()		
			inst.components.naked:AnimWithTits(true)
			
			if fuckmode == "partner" or fuckmode == "gay" then					    
				inst.AnimState:PlayAnimation("doggy_girl", true)
			else
			    inst.AnimState:PlayAnimation("doggy_girl_lez", true)
			end
			
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
		    inst.components.naked:AnimWithTits(false)
			inst:PushEvent("stopfuck")
        end,
    }
	
local titsplay = State{
        name = "titsplay",
        tags = { "nopredict" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
		
			inst.AnimState:PlayAnimation("titsplay", true)
            inst.components.naked:AnimWithTits(true)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
		    inst.components.naked:AnimWithTits(false)
        end,
    }
	
local function AddMonsterFuckSG(sg, sgname, alt, drop)
 	if alt == nil then
		alt = sgname
	end   
	if drop == nil then
	    drop = true
	end
	local returnstate = State{
        name = sgname,
		tags = {"fuck", "busy", "nopredict", "nomorph"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)		
			
			if inst.components.playercontroller then
			    inst.components.playercontroller:Enable(false)
			end
			
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil and drop then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			
			inst:AddTag("CantAttackAtFuck")
			
			if inst.components.naked.havedick == false then
			    if alt == "player_fuck_spiderslut" or alt == "spiderslut_fuck_player" then
			        alt = "spiderslut_fuck_player_fem"
			    end
			end			
			
			inst.AnimState:PlayAnimation(alt, true)
			inst.fuckanim_client:set(alt)
        end,

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopmonsterfuck")
			inst:RemoveTag("CantAttackAtFuck")
			if inst.components.playercontroller then
			    inst.components.playercontroller:Enable(true)
			end
        end,
    }
	sg.states[sgname] = returnstate
end

local function AddFriendlyFuckSG(sg, sgname, alt)
 	if alt == nil then
		alt = sgname
	end
    	
    local returnstate = State{
        name = sgname,
		tags = {"fuck", "friendlyfuck"},

        onenter = function(inst)
	        if inst.components.excited then
		        inst.components.excited.daysnosex = 0
		    end
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end
			
			if inst.components.naked.havedick == false then
			    if alt == "player_fuck_spiderslut" or alt == "spiderslut_fuck_player" then
			        alt = "spiderslut_fuck_player_fem"
			    end
			end
			
			inst.AnimState:PlayAnimation(alt, true)
			inst.fuckanim_client:set(alt)
        end,

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopmonsterfuck")
        end,
    }
	sg.states[sgname] = returnstate
end

local function AddObjectFuckSG(sg, sgname, alt)
 	if alt == nil then
		alt = sgname
	end 
    local returnstate = State{
        name = sgname,
		tags = {"fuck", "objectfuck", "nopredict"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.Transform:SetNoFaced(inst)
			local hands_item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
			if hands_item ~= nil then
			    inst.components.inventory:Unequip(GLOBAL.EQUIPSLOTS.HANDS, false)
				inst.components.inventory:DropItem(hands_item)
			end 
			inst.AnimState:PlayAnimation(alt, true)
			inst.fuckanim_client:set(alt)
        end,
		
        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nopredict")
            end),
        },

        events =
        {

        },

        onexit = function(inst)
			inst:PushEvent("stopmonsterfuck")
        end,
    }
	sg.states[sgname] = returnstate
end

local fap_pigman = State{
        name = "fap",
        tags = { "busy", "fap" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			inst:ClearBufferedAction()
			inst.AnimState:PlayAnimation("faping", false)
        end,

        events =
        {		
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
				    if not inst.cummed then
					    inst:PushEvent("cum")
						inst.cumforrest = inst.cumforrest-1
						inst.cummed = true
                        inst.AnimState:PlayAnimation("cumming", false)
				    elseif inst.cummed then
					    inst.cummed = false
                        inst.AnimState:PlayAnimation("faping", false)
					end
                end
            end),
		},

        onexit = function(inst)
            inst.cummed = false
			inst:RemoveTag("CanCum")
        end,
    }

local function SGWilsonPostInit(sg)
	
	sg.states["suck_state"] = suck_state
	sg.states["suckenjoy_state"] = suckenjoy_state
	sg.states["lick_state"] = lick_state
	sg.states["fap_state"] = fap_state
	sg.states["plush_toy"] = plush_toy
	sg.states["layfuck_state"] = layfuck_state
	sg.states["riderfuck_state"] = riderfuck_state
	sg.states["ropped_state"] = ropped_state
	sg.states["roppedfuck_state"] = roppedfuck_state
	sg.states["flipfuck_girl"] = flipfuck_girl
	sg.states["flipfuck"] = flipfuck
	sg.states["kness_girl"] = kness_girl
	sg.states["kness"] = kness
	sg.states["doggy"] = doggy
    sg.states["doggy_girl"] = doggy_girl
	
	sg.states["dilding"] = dilding
	sg.states["vibrating"] = vibrating
	sg.states["rocketfuck"] = rocketfuck
	sg.states["titsplay"] = titsplay
	
	sg.states["fuck_spider"] = fuck_spider
	
	-- Короче я люто заебался делать одниковые стэйты.
	-- И сделал две функции добавления sg в одну строку.
	-- AddFriendlyFuckSG и AddMonsterFuckSG
	-- Первойую ты можешь отменить, вторую нет.
	-- (sg, имя, анимация) если анимация пуста, 
	-- используем имя в качестве анмации. Изи.
	
	AddFriendlyFuckSG(sg, "player_fuck_spider")
	AddFriendlyFuckSG(sg, "player_fuck_spider2","spider_fuck_player")
	AddFriendlyFuckSG(sg, "player_fuck_merm")
	AddFriendlyFuckSG(sg, "player_fuck_merm2", "merm_fuck_player")
	AddFriendlyFuckSG(sg, "player_fuck_merm_extra1")
	AddFriendlyFuckSG(sg, "merm_fuck_player_bj")
	AddFriendlyFuckSG(sg, "player_fuck_spiderslut")
	AddFriendlyFuckSG(sg, "player_fuck_spiderslut2", "spiderslut_fuck_player")
	
	AddFriendlyFuckSG(sg, "player_fuck_bunny")
    AddFriendlyFuckSG(sg, "player_fuck_bunny2", "bunny_fuck_player")		
	AddFriendlyFuckSG(sg, "player_fuck_slurper", "slurper_fuck_player")	
	AddFriendlyFuckSG(sg, "player_fuck_glommer")
	AddFriendlyFuckSG(sg, "player_fuck_tentacle", "tentacle_fuck_player")	
	AddFriendlyFuckSG(sg, "player_fuck_lureplant", "lureplant_fuck_player")
	AddFriendlyFuckSG(sg, "player_fuck_darkness", "darkness_fuck_player")
	AddFriendlyFuckSG(sg, "player_fuck_catcoon")
	AddFriendlyFuckSG(sg, "player_fuck_catcoon2", "catcoon_fuck_player")
	AddFriendlyFuckSG(sg, "tentacle_fuck_player_wurt")
	AddFriendlyFuckSG(sg, "tentacle_fuck_player_wurt2","tentacle_fuck_player")
	
	AddMonsterFuckSG(sg, "spider_fuck_player")
	AddMonsterFuckSG(sg, "tentacle_fuck_player")
    AddMonsterFuckSG(sg, "merm_fuck_player")
	AddMonsterFuckSG(sg, "bunny_fuck_player")
	AddMonsterFuckSG(sg, "tinytentacle_fuck_player")
	AddMonsterFuckSG(sg, "slurper_fuck_player")	
	AddMonsterFuckSG(sg, "darkness_fuck_player", nil, false)
	AddMonsterFuckSG(sg, "cookie_fuck_player")
	AddMonsterFuckSG(sg, "nightmare1_fuck_player")
	AddMonsterFuckSG(sg, "hound_fuck_player")
	AddMonsterFuckSG(sg, "spiderslut_fuck_player")
	AddMonsterFuckSG(sg, "lureplant_fuck_player")
	AddMonsterFuckSG(sg, "catcoon_fuck_player")
	
	AddObjectFuckSG(sg, "mushroom_red")
	AddObjectFuckSG(sg, "mushroom_blue")	
	AddObjectFuckSG(sg, "mushroom_green")
	
	--Put on states:
	sg.states["puton_body"] = puton_body
	sg.states["puton_legs"] = puton_legs
	sg.states["puton_feet"] = puton_feet
	sg.states["puton_hand"] = puton_hand
	
	sg.states["takeoff_legs"] = takeoff_legs
	sg.states["takeoff_body"] = takeoff_body
	sg.states["takeoff_feet"] = takeoff_feet
	sg.states["takeoff_all"] = takeoff_all
end
--flipfuck_girl
--ThePlayer.sg:GoToState("flipfuck_girl")
AddStategraphPostInit("wilson", SGWilsonPostInit)

local function SGPigmanPostInit(sg)
    sg.states["fap"] = fap_pigman
end
AddStategraphPostInit("pig", SGPigmanPostInit)
AddStategraphPostInit("merm", SGPigmanPostInit)