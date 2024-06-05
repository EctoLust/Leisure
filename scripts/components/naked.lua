local function HaveTits(inst)
    if inst.intim_gender then
	    if inst.intim_gender == "FEMALE" then
		    return true
		else
		    return false
		end
	else
	    return false
	end
end

local function HaveDick(inst)
    if inst.intim_gender then
	    if inst.intim_gender ~= "FEMALE" then
		    return true
		else
		    return false
		end
	else
	    return false
	end
end

local Naked = Class(function(self, inst)
    self.inst = inst
	self.head_skinname = ""
	self.body_skinname = ""
	self.hand_skinname = ""
	self.legs_skinname = ""
	self.feet_skinname = ""
	self.nude_build = GetNudeBuild(self.inst.prefab)
	
	self.havetits = HaveTits(self.inst)
	if self.havetits then	
	    self.titssize = GetDefaultTitsSize(self.inst.prefab)
	else	
	    self.titssize = "none"
	end
	
	self.tits_build = GetTitsBySize(self.inst.prefab, self.titssize)
	if self.tits_build == nil then
	    self.tits_build = self.nude_build
	end
	
	self.havedick = HaveDick(self.inst)	
	
	if self.havedick then
	    self.dick = GetDefaultDick(self.inst.prefab)
		--self.dick = "censor_dick"
	    self.inst.AnimState:OverrideSymbol("dick", self.dick, "dick")
		self.inst:AddTag("HaveDick")
	end
	self.body_nude = false
	self.hand_nude = false
	self.legs_nude = false
	self.feet_nude = false	
	self.stockings = nil
end)

local function SetNude(self)	
	if self.nude_build ~= "" then 	
	    if self.body_nude then  
            Censore(self.inst,0,-58,"torso",0.5,0.2,0.5)		
		    self:SetTits()
		    self.inst.AnimState:OverrideSymbol("arm_upper_skin", self.nude_build, "arm_upper_skin")	
		    self.inst.AnimState:OverrideSymbol("arm_upper", self.nude_build, "arm_upper")	
	    end
	    if self.hand_nude then
	        self.inst.AnimState:OverrideSymbol("hand", self.nude_build, "hand")
		    self.inst.AnimState:OverrideSymbol("arm_upper_skin", self.nude_build, "arm_upper_skin")	
		    self.inst.AnimState:OverrideSymbol("arm_lower", self.nude_build, "arm_lower")	
		    self.inst.AnimState:OverrideSymbol("arm_lower_cuff", self.nude_build, "arm_lower_cuff")	
	    end	
	    if self.legs_nude then
	        Censore(self.inst,0,0,"torso",1,0.2,0.5)
			self.inst.AnimState:OverrideSymbol("leg", self.nude_build, "leg")
		    self.inst.AnimState:OverrideSymbol("skirt", self.nude_build, "skirt")
		    self.inst.AnimState:OverrideSymbol("torso_pelvis", self.nude_build, "torso_pelvis")
			-- This dick that seen in all animations.
			if self.havedick then
			    self.inst.AnimState:OverrideSymbol("swap_body_tall", self.dick, "swap_body_tall")
			end
		else
			if self.havedick then
			    self.inst.AnimState:ClearOverrideSymbol("swap_body_tall")
			end		    
	    end		
	    if self.feet_nude then
	        self.inst.AnimState:OverrideSymbol("foot", self.nude_build, "foot")
	    end
    else -- If Webbeer like characters.
	    if self.legs_nude then
			if self.havedick then
			    self.inst.AnimState:OverrideSymbol("swap_body_tall", self.dick, "swap_body_tall")
			end
		else
			if self.havedick then
			    self.inst.AnimState:ClearOverrideSymbol("swap_body_tall")
			end		    
	    end		
	end
	if self.stockings then
	    -- Always render stockings on legs, because is more sexy!
		self.inst.AnimState:OverrideSymbol("leg", self.stockings , "leg")		
		-- Render feets of stockings only if feets without boots.
		if self.feet_nude then 
		    self.inst.AnimState:OverrideSymbol("foot", self.stockings , "foot")
		end
		-- Is special for stockings that holded by panties.
		if self.legs_nude then		
		    if self.stockings == "stockings_pants" then
		        self.inst.AnimState:OverrideSymbol("torso_pelvis", self.stockings , "torso_pelvis")
			    self.inst.AnimState:OverrideSymbol("torso_pelvis_wide", self.stockings , "torso_pelvis")
		    end
		end
	end
end

local function ResetClothing(self)
	if self.havedick then
		self.inst.AnimState:ClearOverrideSymbol("swap_body_tall")
	end	
    local skins = self.inst.components.skinner
	self.head_skinname = self.inst.components.skinner.skin_name
	self.body_skinname = skins.clothing.body
	self.hand_skinname = skins.clothing.hand
	self.legs_skinname = skins.clothing.legs
	self.feet_skinname = skins.clothing.feet
	self.inst.components.skinner:ClearAllClothing()
    self.inst.AnimState:AssignItemSkins(self.inst.userid, self.body_skinname, self.hand_skinname, self.legs_skinname, self.feet_skinname) 
    self.inst.components.skinner:SetClothing(self.body_skinname)
    self.inst.components.skinner:SetClothing(self.hand_skinname)
    self.inst.components.skinner:SetClothing(self.legs_skinname)
    self.inst.components.skinner:SetClothing(self.feet_skinname)
	if self.inst.nudehand_client then
	    self.inst.nudehand_client:set(self.hand_nude)
	end
	if self.inst.nudebody_client then
	    self.inst.nudebody_client:set(self.body_nude)
	end
	if self.inst.nudelegs_client then
	    self.inst.nudelegs_client:set(self.legs_nude)
	end
	if self.inst.nudefeet_client then
	    self.inst.nudefeet_client:set(self.feet_nude)
	end
end

function Naked:DoReset()
	self.body_nude = false
	self.hand_nude = false
	self.legs_nude = false
	self.feet_nude = false
	ResetClothing(self)
end

function Naked:IsNaked(part)
	if part == "body" then
	    return self.body_nude
	elseif part == "hand" then
	    return self.hand_nude
	elseif part == "legs" then
	    return self.legs_nude
	elseif part == "feet" then
	    return self.feet_nude
	else
	    return false
    end
end

function Naked:PutOnClothing(part, skinname)
    local skins = self.inst.components.skinner
	if part == "body" then
	    self.body_nude = false
		skins.clothing.body = skinname
	elseif part == "hand" then
	    self.hand_nude = false
		skins.clothing.hand = skinname
	elseif part == "legs" then
	    self.legs_nude = false
		skins.clothing.legs = skinname
	elseif part == "feet" then
	    self.feet_nude = false
		skins.clothing.feet = skinname
	elseif part == "stockings" then
	    self.stockings = skinname
    end
	ResetClothing(self)
	SetNude(self)
end

function Naked:Fixup(part)
	ResetClothing(self)
	SetNude(self)
end

function Naked:TakeOffClothing(part)
    local skins = self.inst.components.skinner
	local savename = ""	
	if part == "body" then
		savename = skins.clothing.body
	elseif part == "hand" then
		savename = skins.clothing.hand
	elseif part == "legs" then
		savename = skins.clothing.legs
	elseif part == "feet" then
		savename = skins.clothing.feet
    end
	if self.inst.components.lootdropper and part ~= "stockings" then
	    local dropedclothing = self.inst.components.lootdropper:SpawnLootPrefab("dropedclothing")
		dropedclothing.type = part
		dropedclothing.ku = self.inst.userid
		dropedclothing.userid = self.inst.userid
		dropedclothing.savedname = savename
		
		if dropedclothing.components.skinner.skin_data ~= nil then		
		    dropedclothing.components.skinner.skin_data.normal_skin	= self.inst.components.skinner.skin_data.normal_skin -- Фикс если дефолтный скин сейчас.
		end
	    local head = self.inst.components.skinner.skin_name
	    local body = skins.clothing.body
	    local hand = skins.clothing.hand
	    local legs = skins.clothing.legs
	    local feets = skins.clothing.feet
		
		local set_head = head
		
		if head == self.inst.prefab.."_none" then
		    set_head = ""
		end
		
		if part == "hand" then
		    dropedclothing.AnimState:AssignItemSkins(self.inst.userid, set_head, body, legs, hand) 	
		else
		    dropedclothing.AnimState:AssignItemSkins(self.inst.userid, set_head, body, legs, feets) 	
        end		
		dropedclothing.components.skinner:SetSkinName(head)
		if set_head == "" then
		    dropedclothing.AnimState:SetBuild(self.inst.prefab)
		end
        dropedclothing.components.skinner:SetClothing(body)
        dropedclothing.components.skinner:SetClothing(hand)
        dropedclothing.components.skinner:SetClothing(legs)
        dropedclothing.components.skinner:SetClothing(feets)
	elseif part == "stockings" then	    
		self.inst.components.lootdropper:SpawnLootPrefab(self.stockings)
		self.stockings = nil
	end
	if part == "body" then
	    self.body_nude = true
		skins.clothing.body = ""
	elseif part == "hand" then
	    self.hand_nude = true
		skins.clothing.hand = ""
	elseif part == "legs" then
	    self.legs_nude = true
		skins.clothing.legs = ""
	elseif part == "feet" then
	    self.feet_nude = true
		skins.clothing.feet = ""
    end
	ResetClothing(self)
	SetNude(self)
end

function Naked:IsHasDick()
    if self.havedick then 
	    return true
	else
	    return false
	end
end

function Naked:SetTits()
	if self.nude_build == "" then
	    return false
	end
	
    self.inst.AnimState:OverrideSymbol("torso", self.tits_build, "torso")  
end

function Naked:SetDefaultTits()
    self.titssize = GetDefaultTitsSize(self.inst.prefab)
	if self:IsNaked("body") then		    
     	self:SetTits()
	end
end

function Naked:EnlargeTits(torn)
    if self.titssize == "flat" or self.titssize == "none" then
	    self.titssize = "small"
	elseif self.titssize == "small" then
	    self.titssize = "medium"
	elseif self.titssize == "medium" then
	    self.titssize = "large"
	elseif self.titssize == "large" then
	    return false
    end
	self.tits_build = GetTitsBySize(self.inst.prefab, self.titssize)
	if self.tits_build == nil then
	    self.tits_build = self.nude_build
	end    
	if torn then
		if self:IsNaked("body") then		    
			self:SetTits()
		else
		    self.inst.components.naked:TakeOffClothing("body")
		end
		if self.inst.components.talker then
		    self.inst.components.talker:Say("WOOAH!")
		end	     
	end
end

function Naked:CheckSexGender()
    if self.inst.partner and self.inst.partner.components.naked then
		local iam = self:IsHasDick()
		local mypar = self.inst.partner.components.naked:IsHasDick()
		if iam == false and mypar == false then -- No one have dick
			return "lesbian"
	    elseif iam == true and mypar == true then -- All have dicks
			return "gay"
        elseif iam == true and mypar == false then -- I am have dick          	
			return "iam"
        elseif iam == false and mypar == true then -- Partner have dick
			return "partner"
        else
            print("WARNING!! CANT CHECK SEX TYPE! Caller of function is "..self.inst.prefab.." partner "..self.inst.partner.prefab)
			return "iam"		
		end 	    
	else
	    print("WARNING!! SEX WITH UNKNOW GENDER! Caller of function is "..self.inst.prefab)
	    return "iam"
	end
end

function Naked:AnimWithTits(toggle)
    if not self:IsNaked("body") or HaveSeparatedTits(self.tits_build) == false then
        return
    end
   
    if toggle then
	    self.inst.AnimState:OverrideSymbol("torso", self.tits_build, "torso_notits")
		self.inst.AnimState:OverrideSymbol("tit_l", self.tits_build, "tit_l")
		self.inst.AnimState:OverrideSymbol("tit_r", self.tits_build, "tit_r")
		self.inst.AnimState:OverrideSymbol("nipple_l", self.tits_build, "nipple_l")
		self.inst.AnimState:OverrideSymbol("nipple_r", self.tits_build, "nipple_r")
	else
	    self.inst.AnimState:OverrideSymbol("torso", self.tits_build, "torso")
		self.inst.AnimState:ClearOverrideSymbol("tit_l")
		self.inst.AnimState:ClearOverrideSymbol("tit_r")
		self.inst.AnimState:ClearOverrideSymbol("nipple_l")
		self.inst.AnimState:ClearOverrideSymbol("nipple_r")
	end
end

function Naked:OnSave()	
	return {tits = self.titssize, dick = self.dick, nude_build = self.nude_build}, nil
end

function Naked:OnLoad(data)
    if data ~= nil then
        if data.nude_build then
		    self.nude_build = data.nude_build
		end
	    	
		if data.tits then		    
			if data.tits ~= "none" then
		        self.titssize = data.tits
	            self.tits_build = GetTitsBySize(self.inst.prefab, self.titssize)
	            if self.tits_build == nil then
	                self.tits_build = self.nude_build
	            end
			    self.havetits = true
			else
			    self.titssize = data.tits
				self.tits_build = self.nude_build
			end
		end
		if data.dick then		    
			if data.dick ~= "none" then
			    self.dick = data.dick
			    self.havedick = true
			    self.inst.AnimState:OverrideSymbol("dick", self.dick, "dick")
				if data.dick == "strapon_dick" then
				    self.inst.dildo_client:set(true)
				end
				self.inst:AddTag("HaveDick")
			else
			    self.inst:RemoveTag("HaveDick")
			end
		end
    end
end

return Naked