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
	
	self.eternalvoice = self.inst.soundsname
	self.eternaltalkfont = self.inst.components.talker.font
	self.eternaltalkeroverride = self.inst.talker_path_override
	self.eternalidleanim = self.inst.customidleanim
	
	self.head_skinname = ""
	self.body_skinname = ""
	self.hand_skinname = ""
	self.legs_skinname = ""
	self.feet_skinname = ""
	self.nude_build = GetNudeBuild(self.inst.prefab)
	self.nude_tint = {r = 1, g = 1, b = 1}
	
	self.head_disguise = {}
	self.body_disguise = {}
	self.hand_disguise = {}
	self.legs_disguise = {}
	self.feet_disguise = {}
	
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
	
	local shouldhavedick = HaveDick(self.inst)	
	
	if shouldhavedick then
	    self.dick = GetDefaultDick(self.inst.prefab)
	    self.inst.AnimState:OverrideSymbol("dick", self.dick, "dick")
		self.inst:AddTag("HaveDick")
	end
	self.body_nude = false
	self.hand_nude = false
	self.legs_nude = false
	self.feet_nude = false	
	self.stockings = nil
	--self:SetFullDisguise("wormla")
	--self:Fixup()
end)

function Naked:SetBuildForSymbol(symbol)
    if symbol then
	    local build = nil
		local tint = {r = 1, g = 1, b = 1}
		-- "arm_upper_skin", "arm_lower" and "hand" are exposed parts of arms in most of the skins, need to disquise them aswell if they not overrided.
		-- Hardcoded exception
		if symbol == "arm_upper_skin" then		
			if not self.body_nude and #self.body_disguise ~= 0 then -- If clothing not stripped we have disquise
			    if self.inst.components.skinner.clothing.body == "" then -- if body has no skins on.
					self.inst.AnimState:OverrideSymbol(symbol, self.body_disguise[#self.body_disguise].body, symbol)
					tint = self.body_disguise[#self.body_disguise].tint
					self.inst.AnimState:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)	
					return -- don't process any future.
				end
			end
		end
		if symbol == "arm_lower" or symbol == "hand" then
		    if not self.hand_nude and #self.hand_disguise ~= 0 then
				if self.inst.components.skinner.clothing.hand == "" then
				    self.inst.AnimState:OverrideSymbol(symbol, self.hand_disguise[#self.hand_disguise].build, symbol)
					tint = self.hand_disguise[#self.hand_disguise].tint
					self.inst.AnimState:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
				end
				return -- don't process any future.			    
			end
		end
		
		-- Body
		if symbol == "arm_upper_skin" or symbol == "arm_upper" or symbol == "torso" then		
			if self.body_nude then
				if #self.body_disguise ~= 0 then
			        build = self.body_disguise[#self.body_disguise].body
					tint = self.body_disguise[#self.body_disguise].tint
			    else
			        build = self.nude_build	
                    tint = self.nude_tint					
			    end
			end
		end
		-- Hands
		if symbol == "hand" or symbol == "arm_lower" or symbol == "arm_lower_cuff" then
			if self.hand_nude then
			    if #self.hand_disguise ~= 0 then
			        build = self.hand_disguise[#self.hand_disguise].build
					tint = self.hand_disguise[#self.hand_disguise].tint
			    else
			        build = self.nude_build
                    tint = self.nude_tint					
			    end	
			end    
		end
		-- Legs
		if symbol == "leg" or symbol == "skirt" or symbol == "torso_pelvis" then
			if self.legs_nude then
			    if #self.legs_disguise ~= 0 then
			        build = self.legs_disguise[#self.legs_disguise].legs
					tint = self.legs_disguise[#self.legs_disguise].tint
			    else
			        build = self.nude_build
					tint = self.nude_tint
			    end	
			end	    
		end
		-- Feets
		if symbol == "foot" then
			if self.feet_nude then
			    if #self.feet_disguise ~= 0 then
			        build = self.feet_disguise[#self.feet_disguise].build
					tint = self.feet_disguise[#self.feet_disguise].tint
			    else
			        build = self.nude_build
                    tint = self.nude_tint					
			    end	
			end	 	
		end
		-- Extra
		if symbol == "swap_body_tall" then
            if self.legs_nude then
				if #self.legs_disguise ~= 0 then
				    tint = self.legs_disguise[#self.legs_disguise].tint
					self.inst.AnimState:OverrideSymbol(symbol, self.legs_disguise[#self.legs_disguise].dick, symbol)
					self.inst.AnimState:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
				elseif self:IsHasDick() then
				    tint = self.nude_tint
					self.inst.AnimState:OverrideSymbol(symbol, self.dick, symbol)
					self.inst.AnimState:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
				else
				    self.inst.AnimState:ClearOverrideSymbol(symbol)
				end
			else
			    self.inst.AnimState:ClearOverrideSymbol(symbol)
			end
            return
		end
		
		if build ~= nil and build ~= "" then
		    if tint == nil then
			    tint = {r = 1, g = 1, b = 1}
			end
		    self.inst.AnimState:OverrideSymbol(symbol, build, symbol)
			self.inst.AnimState:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
		end
	end
end

local function SetNude(self)	
	if #self.head_disguise ~= 0 then
	    local head = self.head_disguise[#self.head_disguise]
		self.inst.AnimState:OverrideSymbol("head", head, "head")
		self.inst.AnimState:OverrideSymbol("headbase", head, "headbase")
		self.inst.AnimState:OverrideSymbol("headbase_hat", head, "headbase_hat")
		self.inst.AnimState:OverrideSymbol("cheeks", head, "cheeks")
		self.inst.AnimState:OverrideSymbol("face", head, "face")
		self.inst.AnimState:OverrideSymbol("face_sail", head, "face_sail")
		self.inst.AnimState:OverrideSymbol("hair", head, "hair")
		self.inst.AnimState:OverrideSymbol("hair_hat", head, "hair_hat")
		self.inst.AnimState:OverrideSymbol("hairfront", head, "hairfront")
		self.inst.AnimState:OverrideSymbol("hairpigtails", head, "hairpigtails")
	end
	self:VoiceOverride()
	self:SetTits()
	self:SetBuildForSymbol("arm_upper_skin")
	self:SetBuildForSymbol("arm_upper")
    self:SetBuildForSymbol("hand")
	self:SetBuildForSymbol("arm_lower")
	self:SetBuildForSymbol("arm_lower_cuff")
	self:SetBuildForSymbol("leg")
	self:SetBuildForSymbol("skirt")
	self:SetBuildForSymbol("torso_pelvis")
	self:SetBuildForSymbol("torso_pelvis_wide")
	self:SetBuildForSymbol("foot")
	self:SetBuildForSymbol("swap_body_tall")
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
	if self:IsHasDick() then
		self.inst.AnimState:ClearOverrideSymbol("swap_body_tall")
	end	
	if #self.head_disguise == 0 then
	    self.inst.AnimState:ClearOverrideSymbol("head")
		self.inst.AnimState:ClearOverrideSymbol("headbase")
		self.inst.AnimState:ClearOverrideSymbol("headbase_hat")
		self.inst.AnimState:ClearOverrideSymbol("cheeks")
		self.inst.AnimState:ClearOverrideSymbol("face")
		self.inst.AnimState:ClearOverrideSymbol("face_sail")
		self.inst.AnimState:ClearOverrideSymbol("hair")
		self.inst.AnimState:ClearOverrideSymbol("hair_hat")
		self.inst.AnimState:ClearOverrideSymbol("hairfront")
		self.inst.AnimState:ClearOverrideSymbol("hairpigtails")
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
	    self.inst.nudehand_client:set(not self:CanTakeItOff("hand"))
	end
	if self.inst.nudebody_client then
	    self.inst.nudebody_client:set(not self:CanTakeItOff("body"))
	end
	if self.inst.nudelegs_client then
	    self.inst.nudelegs_client:set(not self:CanTakeItOff("legs"))
	end
	if self.inst.nudefeet_client then
	    self.inst.nudefeet_client:set(not self:CanTakeItOff("feet"))
	end
end

function Naked:DoReset()
	self.body_nude = false
	self.hand_nude = false
	self.legs_nude = false
	self.feet_nude = false
	ResetClothing(self)
end

function Naked:CanTakeItOff(part)
	if part == "body" then
	    if #self.body_disguise ~= 0 then
		    return true
		else
		    return not self.body_nude
		end
	elseif part == "hand" then
	    if #self.hand_disguise ~= 0 then
		    return true
		else
		    return not self.hand_nude
		end
	elseif part == "legs" then
	    if #self.legs_disguise ~= 0 then
		    return true
		else
		    return not self.legs_nude
		end
	elseif part == "feet" then
	    if #self.feet_disguise ~= 0 then
		    return true
		else
		    return not self.feet_nude
		end
	elseif part == "head" then
	    if #self.head_disguise ~= 0 then
		    return true
		else
		    return false
		end
	else
	    return false
    end
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

function Naked:PutOnDisguise(part, _build, _dick, _tits, _tint)
	if part == "body" then
		table.insert(self.body_disguise, {body = _build, tits = _build, tint = _tint})
	elseif part == "hand" then
	    table.insert(self.hand_disguise, {build = _build, tint = _tint})
	elseif part == "legs" then
	    table.insert(self.legs_disguise, {legs = _build, dick = _dick, tint = _tint})
		if (_dick ~= nil and _dick ~= "" and _dick ~= "none") then
		    self.inst:AddTag("HaveDickDisquise")
			self.inst.AnimState:OverrideSymbol("dick", self.legs_disguise[#self.legs_disguise].dick, "dick")
		else
		    self.inst:RemoveTag("HaveDickDisquise")
			self.inst.AnimState:ClearOverrideSymbol("dick")
		end
	elseif part == "feet" then
		table.insert(self.feet_disguise, {build = _build, tint = _tint})
	elseif part == "head" then
	    table.insert(self.head_disguise, _build)
		ClientChangedDisguise(self.inst.userid, self.head_disguise[#self.head_disguise], "Naked:PutOnDisguise")
    end	
	ResetClothing(self)
	SetNude(self)
end

function Naked:Fixup()
	ResetClothing(self)
	SetNude(self)
end

function Naked:SetFullDisguise(prefab, dis_dick, dis_nude, dis_tits, dis_tint)
    local _tint = {r = 1, g = 1, b = 1}
	if dis_tint ~= nil then
	    _tint = dis_tint
	end
	
	self.head_disguise = { prefab }
	self.hand_disguise = { {build = dis_nude, tint = _tint} }
	self.feet_disguise = { {build = dis_nude, tint = _tint} }
	self.legs_disguise = { {legs = dis_nude, dick = dis_dick, tint = _tint} }
	if dis_dick ~= "" and dis_dick ~= "none" then
		self.inst:AddTag("HaveDickDisquise")
		self.inst.AnimState:OverrideSymbol("dick", dis_dick, "dick")
    else
		self.inst:RemoveTag("HaveDickDisquise")
		self.inst.AnimState:ClearOverrideSymbol("dick")	
	end
	
	local _tits = GetTitsBySize(prefab, dis_tits)
	if _tits == nil then 
		_tits = dis_nude
	end
	self.body_disguise = { {body = dis_nude, tits = _tits, tint = dis_tint} }
	
	SetNude(self)
	ClientChangedDisguise(self.inst.userid, prefab, "Naked:SetFullDisguise")
end

function Naked:TakeOffClothing(part)
    local skins = self.inst.components.skinner
	local savename = ""
	local IsDisguise = false
	if part == "body" then
		if #self.body_disguise ~= 0 and self.body_nude then
		    IsDisguise = true
			savename = self.body_disguise[#self.body_disguise].body
		else
		    savename = skins.clothing.body
		end
	elseif part == "hand" then
		if #self.hand_disguise ~= 0 and self.hand_nude then
		    IsDisguise = true
			savename = self.hand_disguise[#self.hand_disguise].build
		else
		    savename = skins.clothing.hand
		end
	elseif part == "legs" then
		if #self.legs_disguise ~= 0 and self.legs_nude then
		    IsDisguise = true
			savename = self.legs_disguise[#self.legs_disguise].legs
		else
		    savename = skins.clothing.legs
		end
	elseif part == "feet" then
		if #self.feet_disguise ~= 0 and self.feet_nude then
		     IsDisguise = true
			 savename = self.feet_disguise[#self.feet_disguise].build
		else
		    savename = skins.clothing.feet
		end
	elseif part == "head" then
	    if #self.head_disguise ~= 0 then
		    IsDisguise = true
			savename = self.head_disguise[#self.head_disguise]
        else
            return		
		end
    end
	if self.inst.components.lootdropper and part ~= "stockings" then
	    local dropedclothing = self.inst.components.lootdropper:SpawnLootPrefab("dropedclothing")
		dropedclothing.type = part
		dropedclothing.ku = self.inst.userid
		dropedclothing.userid = self.inst.userid
		dropedclothing.savedname = savename
		
		if dropedclothing.components.skinner.skin_data == nil then		
		    dropedclothing.components.skinner.skin_data = {}
		end
		dropedclothing.components.skinner.skin_data.normal_skin	= self.inst.components.skinner.skin_data.normal_skin -- Фикс если дефолтный скин сейчас.
	    local head = self.inst.components.skinner.skin_name
	    local body = skins.clothing.body
	    local hand = skins.clothing.hand
	    local legs = skins.clothing.legs
	    local feets = skins.clothing.feet		
		if not IsDisguise then
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
		else
		    dropedclothing.AnimState:SetBuild(savename)
			dropedclothing.disquiseitem = true
			if part == "legs" then
			    dropedclothing.dick = self.legs_disguise[#self.legs_disguise].dick
				dropedclothing.tint = self.legs_disguise[#self.legs_disguise].tint
			elseif part == "body" then
				dropedclothing.tits = self.body_disguise[#self.body_disguise].tits
				dropedclothing.tint = self.body_disguise[#self.body_disguise].tint
			elseif part == "hand" then
			    dropedclothing.tint = self.hand_disguise[#self.hand_disguise].tint
			elseif part == "feet" then
			    dropedclothing.tint = self.feet_disguise[#self.feet_disguise].tint
			end
		end
	elseif part == "stockings" then	    
		self.inst.components.lootdropper:SpawnLootPrefab(self.stockings)
		self.stockings = nil
	end
	if part == "body" then
		if not self.body_nude then
			self.body_nude = true
		    skins.clothing.body = ""
		elseif #self.body_disguise ~= 0 then
		    table.remove(self.body_disguise, #self.body_disguise)
		end
	elseif part == "hand" then
	    if not self.hand_nude then
	        self.hand_nude = true
		    skins.clothing.hand = ""
        elseif #self.hand_disguise ~= 0 then
            table.remove(self.hand_disguise, #self.hand_disguise)	
		end
	elseif part == "legs" then
		if not self.legs_nude then
		    self.legs_nude = true
			skins.clothing.legs = ""
		elseif #self.legs_disguise ~= 0 then
		    table.remove(self.legs_disguise, #self.legs_disguise)
			self.inst:RemoveTag("HaveDickDisquise")
		end
	elseif part == "feet" then
		if not self.feet_nude then
		    self.feet_nude = true
			skins.clothing.feet = ""
		elseif #self.feet_disguise ~= 0 then
		    table.remove(self.feet_disguise, #self.feet_disguise)
		end
	elseif part == "head" then
	    if #self.head_disguise ~= 0 then
			table.remove(self.head_disguise, #self.head_disguise)
			if #self.head_disguise == 0 then
			    ClientChangedDisguise(self.inst.userid, "", "Naked:TakeOffClothing")
			else
			    ClientChangedDisguise(self.inst.userid, self.head_disguise[#self.head_disguise], "Naked:TakeOffClothing")
			end
		end
    end
	ResetClothing(self)
	SetNude(self)
end

function Naked:IsHasDick()
    if (self.dick ~= nil and self.dick ~= "" and self.dick ~= "none") or (#self.legs_disguise ~= 0 and self.legs_disguise[#self.legs_disguise].dick ~= nil and self.legs_disguise[#self.legs_disguise].dick ~= "" and self.legs_disguise[#self.legs_disguise].dick ~= "none") then 
	    return true
	else
	    return false
	end
end

function Naked:SetTits()
	local tint = {r = 1, g = 1, b = 1}
	if self.nude_build ~= "" then
	    if self.body_nude then  
		    if #self.body_disguise ~= 0 then
	            self.inst.AnimState:OverrideSymbol("torso", self.body_disguise[#self.body_disguise].tits, "torso")
			    self.inst.AnimState:OverrideSymbol("torso_wide", self.body_disguise[#self.body_disguise].tits, "torso_wide")
				if self.body_disguise[#self.body_disguise].tint then
				   tint = self.body_disguise[#self.body_disguise].tint
				end
				
		    else
		        self.inst.AnimState:OverrideSymbol("torso", self.tits_build, "torso")
			    self.inst.AnimState:OverrideSymbol("torso_wide", self.tits_build, "torso_wide") 
				if self.nude_tint then
				    tint = self.nude_tint
				end
	        end
	    end
	end

	self.inst.AnimState:SetSymbolMultColour("torso", tint.r, tint.g, tint.b, 1)
	self.inst.AnimState:SetSymbolMultColour("torso_wide", tint.r, tint.g, tint.b, 1)
end

function Naked:SetDefaultTits()
    self.titssize = GetDefaultTitsSize(self.inst.prefab)
	self:SetTits()
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
	if not self:IsNaked("body") then
        return
    end
	local tint = {r = 1, g = 1, b = 1}
    local build = self.tits_build
	if #self.body_disguise ~= 0 then
	    build = self.body_disguise[#self.body_disguise].tits
		tint = self.body_disguise[#self.body_disguise].tint
	else
	    tint = self.nude_tint
	end
	if HaveSeparatedTits(build) == false then
        return
    end
   
    if toggle then
	    self.inst.AnimState:OverrideSymbol("torso", build, "torso_notits")
		self.inst.AnimState:OverrideSymbol("tit_l", build, "tit_l")
		self.inst.AnimState:OverrideSymbol("tit_r", build, "tit_r")
		self.inst.AnimState:OverrideSymbol("nipple_l", build, "nipple_l")
		self.inst.AnimState:OverrideSymbol("nipple_r", build, "nipple_r")
	    self.inst.AnimState:SetSymbolMultColour("tit_l", tint.r, tint.g, tint.b, 1)
	    self.inst.AnimState:SetSymbolMultColour("tit_r", tint.r, tint.g, tint.b, 1)
	    self.inst.AnimState:SetSymbolMultColour("nipple_l", tint.r, tint.g, tint.b, 1)
	    self.inst.AnimState:SetSymbolMultColour("nipple_r", tint.r, tint.g, tint.b, 1)
	else
	    self.inst.AnimState:OverrideSymbol("torso", build, "torso")
		self.inst.AnimState:ClearOverrideSymbol("tit_l")
		self.inst.AnimState:ClearOverrideSymbol("tit_r")
		self.inst.AnimState:ClearOverrideSymbol("nipple_l")
		self.inst.AnimState:ClearOverrideSymbol("nipple_r")
	end
end

function Naked:OnSave()	
	return {
	titsV3 = self.titssize, 
	dickV3 = self.dick, 
	nude_buildV3 = self.nude_build, 
	head_disguiseV2 = self.head_disguise, -- So we don't crash on old mod version.
	body_disguiseV3 = self.body_disguise, 
	hand_disguiseV3 = self.hand_disguise, 
	legs_disguiseV3 = self.legs_disguise, 
	feet_disguiseV3 = self.feet_disguise, 
	}, nil
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
			    self.inst.AnimState:OverrideSymbol("dick", self.dick, "dick")
				if data.dick == "strapon_dick" then
				    self.inst.dildo_client:set(true)
				end
				self.inst:AddTag("HaveDick")
			else
			    self.inst:RemoveTag("HaveDick")
			    self.dick = "none"
			    self.inst.AnimState:ClearOverrideSymbol("dick")
			end
		elseif data.dick == nil or data.dick == "none" or data.dick == "" then
			self.inst:RemoveTag("HaveDick")
			self.dick = "none"
			self.inst.AnimState:ClearOverrideSymbol("dick")
		end
		if data.head_disguiseV2 then
		    self.head_disguise = data.head_disguiseV2
			if #self.head_disguise == 0 then
			    ClientChangedDisguise(self.inst.userid, "", "Naked:OnLoad")
			else
			    ClientChangedDisguise(self.inst.userid, self.head_disguise[#self.head_disguise], "Naked:OnLoad")
			end
		end
		if data.body_disguiseV3 then
		    self.body_disguise = data.body_disguiseV3
		end
		if data.hand_disguiseV3 then
		    self.hand_disguise = data.hand_disguiseV3
		end
		if data.legs_disguiseV3 then
		    self.legs_disguise = data.legs_disguiseV3
			if #self.legs_disguise ~= 0 and self.legs_disguise[#self.legs_disguise].dick ~= "" and self.legs_disguise[#self.legs_disguise].dick ~= "none" then
			    self.inst:AddTag("HaveDickDisquise")
				self.inst.AnimState:OverrideSymbol("dick", self.legs_disguise[#self.legs_disguise].dick, "dick")
			end
		end
		if data.feet_disguiseV3 then
		    self.feet_disguise = data.feet_disguiseV3
		end
		SetNude(self)
    end
end

function Naked:VoiceOverride()
    if #self.head_disguise ~= 0 then
	    local VoiceData = GetReferenceVoiceData(self.head_disguise[#self.head_disguise])
		if VoiceData ~= nil then
		    self.inst.components.talker.font = VoiceData.fontname
			self.inst.soundsname = VoiceData.voicename
			self.inst.talker_path_override = VoiceData.pathoverride
			self.inst.customidleanim = VoiceData.customidle
		end
	else
		self.inst.components.talker.font = self.eternaltalkfont
	    self.inst.soundsname = self.eternalvoice  
		self.inst.talker_path_override = self.eternaltalkeroverride
		self.inst.customidleanim = self.eternalidleanim
	end
end

return Naked