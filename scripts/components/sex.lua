local Sex = Class(function(self, inst)
    self.inst = inst
end)

local function MakeFuckBar(player, mode)
	if mode == nil then
	    mode = "Death"
	end
	local bar = SpawnPrefab("fuckbar")
	if bar and player then
	    bar.myplayer = player
		bar.mode = mode
		player.fuckbar = bar
		bar.Transform:SetPosition(player.Transform:GetWorldPosition())
		bar.Transform:SetPosition(bar:GetPosition().x,4,bar:GetPosition().z)
	end
end

local function StarFuck(layar, fucker, lewdtype, swap)
	if layar and fucker and layar:GetDistanceSqToInst(fucker) < 7 then
		fucker.partner = layar
		layar.partner = fucker
        fucker.bj_oldxy = {fucker.Transform:GetWorldPosition()}
		layar.bj_oldxy = {layar.Transform:GetWorldPosition()}
	    MakeCharacterPhysics(fucker, 0, 0)
		MakeCharacterPhysics(layar, 0, 0)
		fucker.Transform:SetPosition(layar.Transform:GetWorldPosition())
		fucker.AnimState:ClearOverrideSymbol("dick_other")
		layar.AnimState:ClearOverrideSymbol("dick_other")
		RemoveCensore(fucker)
		RemoveCensore(layar)
		if fucker.components.naked:IsHasDick() then		
			layar.AnimState:OverrideSymbol("dick_other", fucker.components.naked.dick, "dick")
		end
		if layar.components.naked:IsHasDick() then		
			fucker.AnimState:OverrideSymbol("dick_other", layar.components.naked.dick, "dick")
		end
		if lewdtype == "sex" then
		    fucker.sg:GoToState("riderfuck_state")
			layar.sg:GoToState("layfuck_state")
            layar.AnimState:SetLayer(LAYER_BACKGROUND)
			layar.components.cumattachable:ChangeLayer(LAYER_BACKGROUND)
            layar.AnimState:SetSortOrder(5)	
			RemoveCensore(layar)
            Censore(layar,40,-47,"torso",0.2,1,0.5)				
		elseif lewdtype == "flipfuck" then
		    fucker.sg:GoToState("flipfuck")
			layar.sg:GoToState("flipfuck_girl")
            fucker.AnimState:SetLayer(LAYER_BACKGROUND)
			fucker.components.cumattachable:ChangeLayer(LAYER_BACKGROUND)
            fucker.AnimState:SetSortOrder(5)
            RemoveCensore(layar)
            Censore(layar,0,-58,"torso",0.5,0.2,0.5)			
		elseif lewdtype == "onkness" then
		    fucker.sg:GoToState("kness")
			layar.sg:GoToState("kness_girl")
            layar.AnimState:SetLayer(LAYER_BACKGROUND)
			layar.components.cumattachable:ChangeLayer(LAYER_BACKGROUND)
            layar.AnimState:SetSortOrder(5)
		elseif lewdtype == "doggy" then
		    fucker.sg:GoToState("doggy")
			layar.sg:GoToState("doggy_girl")
			
			
			local fuckmode = fucker.components.naked:CheckSexGender()
            local bottom = layar			
			
			if fuckmode == "lesbian" or fuckmode == "partner" then			
                bottom = fucker
			end
			
            bottom.AnimState:SetLayer(LAYER_BACKGROUND)
			bottom.components.cumattachable:ChangeLayer(LAYER_BACKGROUND)
            bottom.AnimState:SetSortOrder(5)		
		end
		if layar:HasTag("CHARLIEBITCH") then
		    MakeFuckBar(fucker, "Charlie")
		end
	end
end

local function TryDoWithPartner(layar, fucker, lewdtype, swap)	
	if layar and fucker then
	    if swap then
	        layar.poseswap = true
			fucker.poseswap = true
			StarFuck(layar, fucker, lewdtype, swap)
	    else
		    if (layar.sg:HasStateTag("knockout") or layar.sg:HasStateTag("bedroll") or layar:HasTag("CHARLIEBITCH")) and layar:GetDistanceSqToInst(fucker) < 7 then
			    StarFuck(layar, fucker, lewdtype, swap)
			end
	    end
	end
end

local function MonsterTryFuckPlayer(player, monster, friendly, objectfuck, swap)
    local owner_check = false
	
	if swap == nil then
	    if monster.partner == nil and player.partner == nil then
		    owner_check = true
		else
		    owner_check = false
		end
	else
	    owner_check = true
	end 
	
	if monster.prefab == "shadowpuddle"and monster:HasTag("friendly") then
		friendly = true	
	end
	
	if player.prefab == "wurt" and monster.prefab == "tentacle" then
	    friendly = true	
	end

	
    if player and monster and owner_check and not player.sg:HasStateTag("dead") then
		player.AnimState:ClearOverrideSymbol("dick_other")
		if objectfuck == nil then
		    objectfuck = false
		end
		if not friendly and swap == nil then
		    TheNet:AnnounceDeath(player:GetDisplayName().." going to be raped to death by "..monster:GetDisplayName(), player.entity)	   
	        player.components.health:SetInvincible(true)
		    --player:ShowHUD(false)
		end
	    player.bj_oldxy = {player.Transform:GetWorldPosition()}
		monster.bj_oldxy = {monster.Transform:GetWorldPosition()}
	    MakeCharacterPhysics(player, 0, 0)
		
		if monster.dick ~= nil then
		    player.AnimState:OverrideSymbol("dick_other", monster.dick, "dick")
		end
		--print(monster.dick)
		
		if not monster:HasTag("FUCKOBJECT") then
		    MakeCharacterPhysics(monster, 0, 0)
		end
		if monster:HasTag("FUCKABLESPIDER") then
		    if monster.swapbuildname then
				player.AnimState:OverrideSymbol("leg_s", monster.swapbuildname, "leg")
				player.AnimState:OverrideSymbol("face_s", monster.swapbuildname, "face")
				player.AnimState:OverrideSymbol("body", monster.swapbuildname, "body")
			end
		end
		if monster:HasTag("FUCKABLETENTACLE") or monster:HasTag("FUCKOBJECT") then
		    player.AnimState:AddOverrideBuild(monster.swapbuildname)
			player.whatneedtoclear = monster.swapbuildname
		end
		if monster.prefab == "shadowpuddle" then
		    player.AnimState:AddOverrideBuild("tentacle_arm_black_build")
			player.AnimState:AddOverrideBuild("shadow_hands")
			player.whatneedtoclear = "tentacle_arm_black_build"
		end
		if monster.fuckonkillstate and not friendly and swap == nil then
		    player.sg:GoToState(monster.fuckonkillstate)
		end
		if monster.friendlyfuck and friendly then
		    
			if swap == nil then
			    player.sg:GoToState(monster.friendlyfuck)
			else
			    player.sg:GoToState(swap)
			end
		end		
	    monster.partner = player
		player.partner = monster
		monster:PushEvent("EnterInFuck")
		player.Transform:SetPosition(monster.Transform:GetWorldPosition())
		if not friendly and swap == nil then
		    MakeFuckBar(player)
		end
	end
end

local function TryFuckMonster(player, monster)
    if player and monster then
	    player.bj_oldxy = {player.Transform:GetWorldPosition()}
		if monster:HasTag("FUCKABLESPIDER") then
		    if monster.swapbuildname then
				player.AnimState:OverrideSymbol("leg_s", monster.swapbuildname, "leg")
				player.AnimState:OverrideSymbol("face_s", monster.swapbuildname, "face")
				player.AnimState:OverrideSymbol("body", monster.swapbuildname, "body")
			end
		    player.sg:GoToState("fuck_spider")
			monster.partner = player
			player.partner = monster
			monster:PushEvent("EnterInFuck")
		end
	end
end

local function TryFuckToy(player, monster)
    if player and monster then
		if monster:HasTag("FUCKABLESPIDER") then
		    if monster.swapbuildname then
				player.AnimState:OverrideSymbol("leg_s", monster.swapbuildname, "leg")
				player.AnimState:OverrideSymbol("face_s", monster.swapbuildname, "face")
				player.AnimState:OverrideSymbol("body", monster.swapbuildname, "body")
			end
		end
		if monster.fucktoystate then
		    player.sg:GoToState(monster.fucktoystate)
			player.whatneedtoclear = monster.swapbuildname
		end
		player.toytokill = monster
	end
end

function Sex:Fuck(inst, target, swap)
    TryDoWithPartner(target, inst, "sex", swap)  
	return true
end

function Sex:FlipFuck(inst, target, swap)
    TryDoWithPartner(target, inst, "flipfuck", swap)  
	return true
end

function Sex:FuckOnKness(inst, target, swap)
    TryDoWithPartner(target, inst, "onkness", swap)  
	return true
end

function Sex:FuckDoggy(inst, target, swap)
    TryDoWithPartner(target, inst, "doggy", swap)  
	return true
end

function Sex:FuckMonster(inst, target)
    TryFuckMonster(inst, target)
	return true
end

function Sex:MonsterFuckPlayer(inst, target, dmg)
    target.fuckdamage = dmg
    MonsterTryFuckPlayer(target, inst, false, false)
	return true
end

function Sex:FriedlyMonsterFuck(player, monster)
    MonsterTryFuckPlayer(player, monster, true, false)
	return true
end

function Sex:FriedlyMonsterSwap(player, monster, swap)
    player.poseswap = true
	monster.poseswap = true
	monster:Hide()
    MonsterTryFuckPlayer(player, monster, true, false, swap)
	return true
end

function Sex:FuckMonsterToy(inst, target)
    TryFuckToy(inst, target)
	return true
end

function Sex:FuckObject(player, object)
    MonsterTryFuckPlayer(player, object, true, true)
	return true
end

return Sex