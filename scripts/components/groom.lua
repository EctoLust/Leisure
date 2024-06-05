local Groom = Class(function(self, inst)
    self.inst = inst
	self.pending_owner = nil
	self.owner_ku = ""
	self.owner = nil
	self.foodgoal = false
	self.nakedgoal = false
	self.sexgoal = false
	
	if not self.inst:HasTag("NoGoals") then
	
    self.inst:ListenForEvent("trade", function(_, data)
	    --print("Data.Giver "..data.giver.prefab)
	    if data and (data.giver == self.owner) or (data.giver.groom ~= nil) then
		    return false
		end
		
		if data and data.giver and not self:Claimed() then
		    if self.pending_owner == nil or self.pending_owner == data.giver then
	            self.pending_owner = data.giver
				if self.foodgoal == false then
				    self.foodgoal = true
				    self:GoalsChanged()
				end
			end
		end
	end)
	self.inst:ListenForEvent("CummedOnNude", function(_, data)
	    --print("Data.Wife "..data.wife.prefab)
	    if data and (data.wife == self.owner) or (data.wife.groom ~= nil) then
		    return false
		end
	    if data and data.wife and not self:Claimed() then
		    if self.pending_owner == nil or self.pending_owner == data.wife then
		        self.pending_owner = data.wife
				if self.nakedgoal == false then
				    self.nakedgoal = true
				    self:GoalsChanged()
				end
			end
		end
	end)
	self.inst:ListenForEvent("EnterInFuck", function()
	    --print("Self.Inst.Partner.Prefab"..self.inst.partner.prefab)
		if self.inst.partner and (self.inst.partner == self.owner) or (self.inst.partner.groom ~= nil) then
		    return false
		end
	    if self.inst.partner and self.inst.partner.sg:HasStateTag("friendlyfuck") and not self:Claimed() then
		    if self.pending_owner == nil or self.pending_owner == self.inst.partner then
		        self.pending_owner = self.inst.partner
				if self.sexgoal == false then
				    self.sexgoal = true
				    self:GoalsChanged()
				end
			end
		end
	end)
	
	end
	
	self.inst:DoPeriodicTask(5, function()
	    if self.owner_ku ~= "" and self.owner == nil then
            if self.inst.components.talker then
	            self.inst.components.talker:Say("MY LOVE IS WHERE?")
	        end	
            self:TryReturnLove()			
		end
	end)
end)

function Groom:Boost(new)
	if self.inst.components.follower then
	    self.inst.components.follower.maxfollowtime = nil
	    self.inst.components.follower.targettime = nil
		self.inst.components.follower.keepdeadleader = true
	end
	
	if self.inst:HasTag("NoBoost") then
	    return
	end

    if self.inst.components.health then
	    local hp = self.inst.components.health -- shortcut on health component
		if new then -- Only if we do it first time. (Not restore after load)
		    local bonus = hp.maxhealth/2 -- 0.5
		    hp.maxhealth = hp.maxhealth+bonus -- healthmax incresses on 0.5
		end
		if hp.regen == nil then -- Have not regen
		    hp:StartRegen(1, 3)
		end
	end
	if self.inst.components.combat then
	    local combat = self.inst.components.combat
		local newdmg = combat.defaultdamage + combat.defaultdamage/3 -- +0.33
	    combat:SetDefaultDamage(newdmg)
	end
	if self.inst.components.homeseeker then -- Not return to home anymore.
	    self.inst.components.homeseeker.home = nil
	end
	if self.inst.components.sleeper and self.inst.components.sleeper.sleeptestfn then -- Removing specific sleeping tests.
		--self.inst.components.sleeper:SetSleepTest(DefaultSleepTest)
		self.inst.components.sleeper:SetSleepTest(function()
		    return false
		end)
	end
	-- if self.inst.LightWatcher ~= nil then -- Very crappy hack.
	    -- self.inst.LightWatcher.GetLightValue = function()
		    -- return 1
		-- end
	-- end
end

function Groom:Claimed()
    if self.owner_ku == "" or self.owner == nil then
	    return false
	else
	    return true
	end
end

function Groom:KillFx()
    if self.fx ~= nil then
	    self.fx:Remove()
		self.fx = nil
	end	
end

function Groom:MakeFx()
    if self.fx ~= nil then
	    self.fx:Remove()
		self.fx = nil
	end	
	local fx = SpawnPrefab("lewdlovefx")
	fx.entity:SetParent(self.inst.entity) 
    fx.entity:AddFollower()

    local symbol = "pig_torso"
	if self.lovefxsymbol ~= nil then
	    symbol = self.lovefxsymbol
	end
	
    fx.Follower:FollowSymbol(self.inst.GUID, symbol, 0, 0, 0)
    self.fx = fx	
end

function Groom:Link(guy)
    self.owner = guy
	self.owner_ku = guy.userid
	guy.groom = self.inst
    guy:ListenForEvent("onremove", function()
	    self.owner = nil
		print("Unlink owner "..self.owner_ku)
	end)
	self.inst:ListenForEvent("onremove", function()
	    if self.owner ~= nil then
		    self.owner.groom = nil
		end
	end)
	if self.inst.prefab == "spiderqueen" then
	    self.inst.components.follower:AddLoyaltyTime(3000000)
	    self.inst.components.follower.maxfollowtime = nil
	    self.inst.components.follower.targettime = nil
	    self.inst.components.follower.keepdeadleader = true
	end
	guy.components.leader:AddFollower(self.inst)
	
	print("Linked to "..guy.prefab.." ("..guy.userid..")")
end

function Groom:Claim()
    self.owner = self.pending_owner
	self.owner_ku = self.owner.userid
	print("Goals complite caliming to "..self.owner.prefab.." ("..self.owner_ku..")")
	self:Link(self.owner)
	self:Boost(true)
	self:MakeFx()
end

function Groom:GoalsChanged()
	if self.pending_owner then
	    self.pending_owner:PushEvent("makefriend")
		self.inst.components.follower:AddLoyaltyTime(30)
		self.inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
		self.pending_owner.components.leader:AddFollower(self.inst)
	end
    if self.foodgoal and self.nakedgoal and self.sexgoal and self.owner == nil then
	    self:Claim()
	end
end

function Groom:SayRefuse()
    if self.inst.components.talker then
	    self.inst.components.talker:Say("MY HAVE LOVE ALREADY!")
	end
end

function Groom:TryReturnLove()
    local love = FindEntity(self.inst, 8, function(item) return item:HasTag("player") and item.userid == self.owner_ku end, nil, { "" })
    if love then
	    if love.groom == nil then
	        print("Relinking prefab to "..love.prefab.."("..love.userid..")")
	        self:Link(love)
            if self.inst.components.talker then
	            self.inst.components.talker:Say("LOVE BACK!")
	        end
		else
            print("Relinking Failed! "..love.prefab.."("..love.userid..") has been seen with new partner.")
			if self.inst.components.talker then
	            self.inst.components.talker:Say("TRATOR! YOU BAD!")
				if self.inst.components.combat then
				    self.inst.components.combat:SetTarget(love)
				end
				self:KillFx()
				self.owner = nil
				self.owner_ku = ""
				self.pending_owner = nil
	            self.foodgoal = false
	            self.nakedgoal = false
	            self.sexgoal = false
	        end		
        end		
    end	
end

function Groom:OnSave()
    return {ku = self.owner_ku}, nil
end

function Groom:OnLoad(data)
    if data ~= nil then
        if data.ku and data.ku ~= "" then
		    self.owner_ku = data.ku
	        self.foodgoal = true
	        self.nakedgoal = true
	        self.sexgoal = true
			self:Boost(false)
			self:MakeFx()
		end
    end
end

return Groom