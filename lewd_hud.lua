local require = GLOBAL.require
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIFONT = GLOBAL.UIFONT

local lube_bage = GLOBAL.require("widgets/lube_bage")
local sticky_bage = GLOBAL.require("widgets/sticky_bage")
local libido_bage = GLOBAL.require("widgets/libido_bage")

--ui_boobs

local PlayerProfile = GLOBAL.require("playerprofile")


local function ClientProfileSet(self)
    self:SetValue("LewdReg", true)
    self.dirty = true
    self:Save()
end

local function ClientProfileReset(self)
    self:SetValue("LewdReg", nil)
    self.dirty = true
    self:Save()
end

local function ClientProfileGet(self)
    return self:GetValue("LewdReg")
end

PlayerProfile.LewdReg = ClientProfileSet
PlayerProfile.GetReg = ClientProfileGet
PlayerProfile.ResetReg = ClientProfileReset

local function LewdUnlockAnim(self, name)
    if self:GetValue(name) ~= "true" then
        self:SetValue(name, "true")
        self.dirty = true
        self:Save()
	end
end

local function LewdAnimUnlocked(self, name)
    return self:GetValue(name)
end

PlayerProfile.LewdUnlockAnim = LewdUnlockAnim
PlayerProfile.LewdAnimUnlocked = LewdAnimUnlocked

local function AddToInvBar(self)
    self.cumbook = self.root:AddChild(Image("images/bookincum.xml", "bookincum.tex"))
	self.cumbook:SetPosition(0, 100)
	self.cumbook:SetOnGainFocus(function() self.cumbook:OnGainFocus() end)
	self.cumbook:SetOnLoseFocus(function() self.cumbook:OnLoseFocus() end)
	self.cumbook:SetTint(1,1,1,0.1)
	local save_self = self
	function self.cumbook:OnGainFocus()
        save_self.cumbook:SetTint(1,1,1,1) 
	end
	function self.cumbook:OnLoseFocus()
        save_self.cumbook:SetTint(1,1,1,0.1) 
	end	
	function self.cumbook:OnControl(control, down)
		if control == GLOBAL.CONTROL_ACCEPT then
			if down then
				save_self.down = true
			elseif save_self.down then
			    save_self.down = false
	            local NextScreen = GLOBAL.require "screens/lewdlog"
	            local openscreen = NextScreen(save_self)
	            GLOBAL.TheFrontEnd:PushScreen(openscreen)  				
			end
		end
	end
end

AddClassPostConstruct("widgets/inventorybar", AddToInvBar)

local function onuiclock(self)
    
	if self._anim then
	    self.ui_anticum = self._anim:AddChild(Image("images/ui_anticum.xml", "ui_anticum.tex"))
	    self.ui_anticum:SetPosition(-79, -30)
	    self.ui_anticum_text = self._anim:AddChild(Text(UIFONT, 30, "3"))
	    self.ui_anticum_text:SetPosition(-79, -30)
		
	    self.ui_boobs = self._anim:AddChild(Image("images/ui_boobs.xml", "ui_boobs.tex"))
	    self.ui_boobs:SetPosition(-157, -30)
	    self.ui_boobs_text = self._anim:AddChild(Text(UIFONT, 30, "3"))
	    self.ui_boobs_text:SetPosition(-157, -30)
		self.ui_boobs_text:SetColour(0,0,0,1)
		
	    self.ui_dildo = self._anim:AddChild(Image("images/ui_dildo.xml", "ui_dildo.tex"))
	    self.ui_dildo:SetPosition(-235, -30)
		
	    function self.ui_dildo:OnControl(control, down)
		    if control == GLOBAL.CONTROL_ACCEPT then
			    if down then
				    self.down = true
			    elseif self.down then
			        self.down = false
				    GLOBAL.SendModRPCToServer(MOD_RPC["LEWD"]["UNDILDO"], GLOBAL.ThePlayer)
			    end
		    end
	    end
		
		local player = GLOBAL.ThePlayer
		
        player:ListenForEvent("lewdstart.client", function(inst)
	        local LewdStartScreen = GLOBAL.require "screens/lewdstart"
	        local openscreen = LewdStartScreen(self)
	        GLOBAL.TheFrontEnd:PushScreen(openscreen) 
        end)
        player:ListenForEvent("lustbook.client", function(inst)
	         local LustScreen = GLOBAL.require "screens/lustbookscreen"
	         local openscreen = LustScreen(self)
	         GLOBAL.TheFrontEnd:PushScreen(openscreen)    
        end)
        player:ListenForEvent("lewddisguisekit.client", function(inst)
	         local Screen = GLOBAL.require "screens/lewddisguisekit"
	         local openscreen = Screen(self)
	         GLOBAL.TheFrontEnd:PushScreen(openscreen)    
        end)		
		
		GLOBAL.ThePlayer:DoPeriodicTask(0.5, function()
		    if GLOBAL.ThePlayer.dildo_client:value() then
			    self.ui_dildo:Show()
			else
			    self.ui_dildo:Hide()
			end
		end)
		
        GLOBAL.ThePlayer.UpdateLewdBuffsBages = function()
		    local player = GLOBAL.ThePlayer
			local anticum_value = player.anticum_client:value()
			local boobs_value = player.boobs_client:value()
			if anticum_value > 0 then
			    self.ui_anticum:Show()
				self.ui_anticum_text:Show()
				self.ui_anticum_text:SetString(anticum_value)
			else
			    self.ui_anticum:Hide()
				self.ui_anticum_text:Hide()	
			end
			if boobs_value > 0 then
			    self.ui_boobs:Show()
				self.ui_boobs_text:Show()
				self.ui_boobs_text:SetString(boobs_value)
			else
			    self.ui_boobs:Hide()
				self.ui_boobs_text:Hide()	
			end
        end
	    self.ui_anticum:Hide()
		self.ui_anticum_text:Hide()	
		self.ui_boobs:Hide()
		self.ui_boobs_text:Hide()			
	end
end

local function onstatusdisplaysconstruct(self)
	self.hud_lube = self:AddChild(lube_bage(self,self.owner))
	self.hud_sticky = self:AddChild(sticky_bage(self,self.owner))
	self.hud_libido = self:AddChild(libido_bage(self,self.owner))
	
    if GLOBAL.KnownModIndex:IsModEnabled("workshop-376333686") then
		self.hud_lube:SetPosition(-62, -52)
		self.hud_sticky:SetPosition(-142, -52)
    else
		self.hud_lube:SetPosition(-80, -40)
		self.hud_sticky:SetPosition(-160, -40)
		self.hud_libido:SetPosition(-80, 75)
    end
    self.owner.UpdateLubeBage = function()
	    local lube_value = self.owner.lube_client:value()
		local sticky_value = self.owner.stickysalve_client:value()
		local havesex = self.owner.fucks_client:value()
		local fap = self.owner.fap_client:value()
		local libido = self.owner.libido_client:value()
		local libido_on = self.owner.libido_on_client:value()
		
		self.hud_lube:SetPercent(lube_value,40,havesex)  
        self.hud_sticky:SetPercent(sticky_value,20,havesex)
		self.hud_libido:SetPercent(libido,100, havesex, fap)
		
        if lube_value > 0 then
		    self.hud_lube:Show()
        else
		    self.hud_lube:Hide()
        end	
        if sticky_value > 0 then
		    self.hud_sticky:Show()
		else
		    self.hud_sticky:Hide()
        end
		if libido_on or libido > 0 then
		    self.hud_libido:Show()
		else
		    self.hud_libido:Hide()
		end
    end
	self.hud_lube:Hide()
	self.hud_sticky:Hide()
	self.hud_libido:Hide()
end

AddClassPostConstruct("widgets/statusdisplays", onstatusdisplaysconstruct)
AddClassPostConstruct("widgets/uiclock", onuiclock)

local function Syn(inst)
	local lube = inst.lube
	local anticum = inst.anticumday
	local boobs = inst.boobsresize
	local sticky = inst.stickysalve
	local libido = inst.components.excited.libido
	local libido_on = inst.components.excited.enable
	
	if inst.partner ~= nil then
	    inst.fuckerprefab_client:set(inst.partner.prefab)
	else
	    inst.fuckerprefab_client:set("")
	end
	
	if lube == nil then
	    lube = 0
	end
	if sticky == nil then
	    sticky = 0
	end
	if anticum == nil then
	    anticum = 0
	end
	if boobs == nil then
	    boobs = 0
	end
	if inst.sg and inst.sg:HasStateTag("fuck") then
	    inst.fucks_client:set(true)
	else
	    inst.fucks_client:set(false)
	end
	if inst.sg and inst.sg:HasStateTag("fap") then
	    inst.fap_client:set(true)
	else
	    inst.fap_client:set(false)	    
	end
	
	
	if inst.firstsexwith then
	    local fucker = inst.firstsexwith
		if fucker == "" then
		    fucker = "no yet"
		end
		inst.firstfuckername_client:set(fucker)
	end
	inst.lube_client:set(lube)
	inst.libido_client:set(libido)
	inst.libido_on_client:set(libido_on)
	inst.anticum_client:set(anticum)
	inst.boobs_client:set(boobs)
	inst.stickysalve_client:set(sticky)
end

local function HUDupdate(inst)
    if GLOBAL.ThePlayer then
	    GLOBAL.ThePlayer.UpdateLubeBage()
	end
end

local function UIClockUpdate(inst)
    if GLOBAL.ThePlayer then
	    GLOBAL.ThePlayer.UpdateLewdBuffsBages()
	end
end

local rpc_debug = false
AddModRPCHandler("LEWD", "TAKEOFF", function(inst, wtf, typeoff)
    if rpc_debug == true then
	    print("PLAYER/KU "..tostring(inst))
	    print("KLEI DATA "..tostring(wtf))
	    print("TYPEOFF "..tostring(typeoff))
	end
    if inst == nil or inst:HasTag("playerghost") or not inst.sg:HasStateTag("idle") then 
	    return 
	else
        if inst.sg:HasStateTag("idle") and inst.components.naked then		    			
			if typeoff ~= "all" and typeoff ~= "stockings" then	
			    if inst.components.naked:CanTakeItOff(typeoff) then		
			        if typeoff ~= "hand" then
			            inst.sg:GoToState("takeoff_"..typeoff)
			        else
			            inst.components.naked:TakeOffClothing("hand")
			        end
			    end
			elseif typeoff == "all" then
			    if inst.components.naked:CanTakeItOff("hand") and inst.components.naked:CanTakeItOff("body") 
				and inst.components.naked:CanTakeItOff("legs") and inst.components.naked:CanTakeItOff("feet") then	
				    inst.sg:GoToState("takeoff_all")
				end
			elseif typeoff == "stockings" then
			    inst.components.naked:TakeOffClothing("stockings")
			end
		end
	end
end)

AddModRPCHandler("LEWD", "AVOID", function(inst, wtf)
    if rpc_debug == true then
	    print("PLAYER/KU "..tostring(inst))
	    print("KLEI DATA "..tostring(wtf))
	end
    if inst == nil or inst:HasTag("playerghost") or inst.fuckbar == nil then 
	    return 
	else
        if inst.fuckbar then
		    inst.fuckbar:PushEvent("Avoid")
		end
	end
end)

AddModRPCHandler("LEWD", "UNDILDO", function(inst, wtf)
    if inst == nil or inst:HasTag("playerghost") then 
	    return 
	else
	    if inst.components.naked.dick == "strapon_dick" then
	        inst.components.naked.dick = "none"
	        inst.AnimState:ClearOverrideSymbol("dick")
			inst.AnimState:ClearOverrideSymbol("swap_body_tall")
		    inst.dildo_client:set(false) 
            inst.components.lootdropper:SpawnLootPrefab("strapon")
			inst:RemoveTag("HaveDick")
        end		
	end
end)


AddModRPCHandler("LEWD", "POSE", function(inst, wtf, pose)
    if rpc_debug == true then
	    print("PLAYER/KU "..tostring(inst))
	    print("KLEI DATA "..tostring(wtf))
	    print("POSE "..tostring(pose))
	end
    if inst and inst.partner and (inst.partner:HasTag("player") or inst.partner:HasTag("PLAYERALIKE")) then 
		local target = inst.partner
		local me = inst
		
        if pose == "strip" then
            if target.components.naked then				
				if target.components.naked:CanTakeItOff("hand") then target.components.naked:TakeOffClothing("hand") end
				if target.components.naked:CanTakeItOff("body") then target.components.naked:TakeOffClothing("body") end
				if target.components.naked:CanTakeItOff("legs") then target.components.naked:TakeOffClothing("legs") end
				if target.components.naked:CanTakeItOff("feet") then target.components.naked:TakeOffClothing("feet") end
		    end
            return			
		end
		
		if pose == "swap" then
		    if inst.poseinverted == nil or inst.poseinverted == false then
			    inst.poseinverted = true
			elseif inst.poseinverted == true then
			    inst.poseinverted = false
			end	
			inst.partner.poseinverted = inst.poseinverted
			pose = inst.lastsexpose or "oral"
		else
		    inst.lastsexpose = pose
			inst.partner.lastsexpose = pose
		end
		
		local invert = inst.poseinverted
		
		if invert then
		    target = inst
			me = inst.partner
		end
		
		if pose == "oral" then
		    inst.components.bj:SuckOff(me, target, true)
		elseif pose == "ride" then
		    inst.components.sex:Fuck(me, target, true)
		elseif pose == "flipfuck" then
		    inst.components.sex:FlipFuck(me, target, true)	
		elseif pose == "onkness" then
		    inst.components.sex:FuckOnKness(me, target, true)	
		elseif pose == "doggy" then
		    inst.components.sex:FuckDoggy(me, target, true)
		end
	else
	    return
	end
end)

AddModRPCHandler("LEWD", "POSE_MONSTER", function(inst, wtf, pose)
    if rpc_debug == true then
	    print("PLAYER/KU "..tostring(inst))
	    print("KLEI DATA "..tostring(wtf))
	    print("POSE "..tostring(pose))
	end
    if inst and inst.partner and inst.sg:HasStateTag("friendlyfuck")then 
		local target = inst.partner
		inst.components.sex:FriedlyMonsterSwap(inst, target, pose)
	else
	    return
	end
end)

AddModRPCHandler("LEWD", "SPAWNED", function(inst, wtf, tits, dick, nude, dis, dis_dick, dis_nude, dis_tits, _r, _g, _b, rdis, gdis, bdis)
	if inst == nil then 
	    return 
	else
        inst.bodyconfigstate = "done"
		if inst.components.naked then		    			           			
			inst.components.naked.nude_build = nude
			inst.components.naked.nude_tint = {r =_r, g = _g, b = _b}
			
			if tits ~= "" and tits ~= "none" then			
			    inst.components.naked.havetits = true
			    inst.components.naked.titssize = tits
				inst.components.naked.tits_build = GLOBAL.GetTitsBySize(inst.prefab, inst.components.naked.titssize)
				if inst.components.naked.tits_build == nil then
				    inst.components.naked.tits_build = inst.components.naked.nude_build
				end
			else
			    inst.components.naked.havetits = false
			    inst.components.naked.titssize = "none"
				inst.components.naked.tits_build = inst.components.naked.nude_build
			end
			
			if dick ~= "" and dick ~= "none" then
			    inst.components.naked.dick = dick
				inst.AnimState:OverrideSymbol("dick", dick, "dick")
				inst:AddTag("HaveDick")
            else	
			    inst.components.naked.dick = "none"
                inst.AnimState:ClearOverrideSymbol("dick")
                inst:RemoveTag("HaveDick")				
			end
			
			if dis and dis ~= "" then
			    inst.components.naked:SetFullDisguise(dis, dis_dick, dis_nude, dis_tits, {r = rdis, g = gdis, b = bdis})
				inst.components.naked:Fixup()
			end
	        print("[RPC] Tits "..inst.components.naked.titssize)	
	        print("[RPC] Dick "..inst.components.naked.dick)
	        print("[RPC] Nude skin "..inst.components.naked.nude_build)
			print("[RPC] R "..inst.components.naked.nude_tint.r)
			print("[RPC] G "..inst.components.naked.nude_tint.g)
			print("[RPC] B "..inst.components.naked.nude_tint.b)
			print("[RPC] Dis Prefab "..dis)
			print("[RPC] Dis Nude "..dis_nude)
			print("[RPC] Dis Tits "..dis_tits)
			print("[RPC] Dis R "..rdis)
			print("[RPC] Dis G "..gdis)
			print("[RPC] Dis B "..bdis)
		end
		GLOBAL.SpawnEffect(GLOBAL.TheWorld.spawn_portal,inst)
		if inst.userid == "KU_FN8AJYjo" then
		    inst.components.inventory:GiveItem(GLOBAL.SpawnPrefab("buttplug"))
		end
		
		if TUNING.LUSTBOOK_ONSPAWN == 1 then
		    inst.components.inventory:GiveItem(GLOBAL.SpawnPrefab("lustbook_item"))
		end
		inst.sg:GoToState("idle") -- sometimes special custom idle can play in time of spawn. Animation can start before we apply disguise. So we gotta reset it to idle, to not show off identity by old special idle anim.
	end
end)

AddModRPCHandler("LEWD", "DISKIT", function(inst, wtf, part, data, titssize, dick)
    if inst ~= nil and not inst:HasTag("playerghost") then 
		if part ~= nil and part ~= "" and data ~= nil and data ~= "" then
		    if part == "head" then
			    inst.components.naked:PutOnDisguise("head", data)
				inst.sg:GoToState("puton_head")
			elseif part == "body" then
	            local tits = GetTitsBySize(data, titssize)
	            if tits == nil then 
		            tits = data
	            end			    
				inst.components.naked:PutOnDisguise("body", tits, nil, titssize)
				inst.sg:GoToState("puton_body")
			elseif part == "hands" then
			    inst.components.naked:PutOnDisguise("hand", data)
				inst.sg:GoToState("puton_hand")
			elseif part == "legs" then
			    inst.components.naked:PutOnDisguise("legs", data, dick, nil)
				inst.sg:GoToState("puton_legs")
            elseif part == "feets" then
                inst.components.naked:PutOnDisguise("feet", data)	
                inst.sg:GoToState("puton_feet")				
			end
		else
		    inst.sg:GoToState("idle")
	    end
	end
end)


AddPrefabPostInit("cumnew", function(inst) 

end)

local function customhppostinit(inst)
	GLOBAL.RegisterDisguiseNetHook(inst)
	
	inst.lube_client = GLOBAL.net_shortint(inst.GUID, "lube.client", "lube_clientdirty")
	inst.stickysalve_client = GLOBAL.net_shortint(inst.GUID, "stickysalve.client", "stickysalve_clientdirty")
	inst.anticum_client = GLOBAL.net_shortint(inst.GUID, "anticum.client", "anticum_clientdirty")
	inst.boobs_client = GLOBAL.net_shortint(inst.GUID, "boobs.client", "boobs_clientdirty")
	inst.fucks_client = GLOBAL.net_bool(inst.GUID, "fucks.client", "fucksdirty")
	inst.fap_client = GLOBAL.net_bool(inst.GUID, "fap.client", "fapsdirty")
	
	inst.firstfuckername_client = GLOBAL.net_string(inst.GUID, "firstfuckername.client", "firstfuckername_clientdirty")
	inst.libido_client = GLOBAL.net_shortint(inst.GUID, "libido.client", "libido_clientdirty")
	
	inst.nudehand_client = GLOBAL.net_bool(inst.GUID, "nudehand.client")
	inst.nudebody_client = GLOBAL.net_bool(inst.GUID, "nudebody.client")
	inst.nudelegs_client = GLOBAL.net_bool(inst.GUID, "nudelegs.client")
	inst.nudefeet_client = GLOBAL.net_bool(inst.GUID, "nudefeet.client")
	inst.dildo_client = GLOBAL.net_bool(inst.GUID, "dildo.client")
	inst.libido_on_client = GLOBAL.net_bool(inst.GUID, "libido_on.client")
	
	inst.lustbook_client = GLOBAL.net_event(inst.GUID, "lustbook.client")
	inst.lewddisguisekit_client = GLOBAL.net_event(inst.GUID, "lewddisguisekit.client")
	
	inst.lewdstart_client = GLOBAL.net_event(inst.GUID, "lewdstart.client")
	
	inst.fuckerprefab_client = GLOBAL.net_string(inst.GUID, "fuckerprefab.client", "fuckerprefab_clientdirty")
	inst.fuckanim_client = GLOBAL.net_string(inst.GUID, "fuckanim.client", "fuckanim_clientdirty")
	inst.fuckanim_last = ""
	
	inst:DoPeriodicTask(0.5, function()
        local sexanim = inst.fuckanim_client:value()
		if sexanim ~= nil and GLOBAL.LEWD_CATALOG_ANIMS[sexanim] ~= nil and inst.fuckanim_last ~= sexanim then
		    local group = ""
			for x = 1, #GLOBAL.LEWD_CATALOG, 1 do
			    if sexanim == GLOBAL.LEWD_CATALOG[x]["anim"] then
			        group = GLOBAL.LEWD_CATALOG[x]["group"]
				    break
				end
			end
			if not GLOBAL.Profile:LewdAnimUnlocked(sexanim) then
			    print("Unlocked anim  "..sexanim.." at category "..group)
				GLOBAL.Profile:LewdUnlockAnim(sexanim)
			end
			inst.fuckanim_last = sexanim
		end
	end)
	
	if GLOBAL.TheWorld.ismastersim then
	    inst:DoPeriodicTask(0.5, function()
            Syn(inst)
	    end)
	end
	
    if not GLOBAL.TheNet:IsDedicated() then
	    inst:ListenForEvent("fuckerprefab_clientdirty", HUDupdate)
        inst:ListenForEvent("lube_clientdirty", HUDupdate)
		inst:ListenForEvent("libido_clientdirty", HUDupdate)
		inst:ListenForEvent("libido_on.client", HUDupdate)
		inst:ListenForEvent("stickysalve_clientdirty", HUDupdate)
		inst:ListenForEvent("firstfuckername_clientdirty", HUDupdate)
		inst:ListenForEvent("fucksdirty", HUDupdate)
		inst:ListenForEvent("anticum_clientdirty", UIClockUpdate)
		inst:ListenForEvent("boobs_clientdirty", UIClockUpdate)	
    end
end

AddPlayerPostInit(customhppostinit)

-- local function craftinghud(self)
    -- self.page_spinner:Hide()
	-- self.pin_slots = {}
	-- TUNING.MAX_PINNED_RECIPES = 0
-- end

-- AddClassPostConstruct("widgets/redux/craftingmenu_pinbar", craftinghud)