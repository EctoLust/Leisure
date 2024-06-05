--splash_spiderweb

local function RetrunPhisics(inst)
    if inst.prefab ~= "lureplant" then
	    if inst.prefab == "tentacle" or inst.prefab == "wormla_vine" then
	        inst.Physics:SetCylinder(0.25, 2)
	    else
	        GLOBAL.MakeCharacterPhysics(inst, 75, .5)
		end
	else
        inst:SetPhysicsRadiusOverride(.7)
        GLOBAL.MakeObstaclePhysics(inst, inst.physicsradiusoverride)	
	end
	
	if inst.bj_oldxy then
	    inst.Transform:SetPosition(inst.bj_oldxy[1],inst.bj_oldxy[2],inst.bj_oldxy[3])
	end
end

local function Cum(inst)
	inst.intim_orgasmsecondsleft = inst.intim_orgasmwait
	for x = 1, inst.intim_orgasmcount, 1 do
	local decay = 0.3+x/7
    inst:DoTaskInTime(decay, function()
        local cumfx = "cumfx"
		local fx = GLOBAL.SpawnPrefab(cumfx)
	    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if x == inst.intim_orgasmcount then
	        local puddle = GLOBAL.SpawnPrefab("ice_puddle")
			local size = 0.7
	        puddle.Transform:SetPosition(inst.Transform:GetWorldPosition())
			puddle.Transform:SetScale(size,size,size)
	        puddle.AnimState:SetMultColour(inst.cumcolor[1], inst.cumcolor[2], inst.cumcolor[3], inst.cumcolor[4])	
            fx.AnimState:SetMultColour(inst.cumcolor[1], inst.cumcolor[2], inst.cumcolor[3], inst.cumcolor[4])			
			puddle:DoTaskInTime(9, GLOBAL.ErodeAway)
		end
	end)
	end
end

local function OrgasmicCheck(inst) 
    if inst:HasTag("HavingSex") or inst:HasTag("CanCum") then
	    if inst.intim_orgasmsecondsleft > 0 then
	        inst.intim_orgasmsecondsleft = inst.intim_orgasmsecondsleft-1
	    end
	    if inst.intim_orgasmsecondsleft == 0 then
            inst:PushEvent("cum")
	    end
	end
end

local function OnRemoveDeath(inst)
    if inst.partner then
        inst.partner:DoTaskInTime(0.1, 
		function()
		    if inst.partner and inst.partner.sg:HasStateTag("fuck") then
				inst.partner:PushEvent("stopmonsterfuck")
		    end
			inst.partner = nil 
		end)
	end
end

local function ExitFuck(inst)
	if inst.poseswap == true then
	    inst.poseswap = nil
		inst:Show()
		return
	end
    if inst:HasTag("HavingSex") then
    RetrunPhisics(inst)
    inst:RemoveTag("HavingSex")
	if inst.components.combat then
	    inst.components.combat.canattack = true
	end
	
    if inst.partner then
        inst:DoTaskInTime(0.1, 
		function()
		    if inst.partner and inst.partner.sg:HasStateTag("fuck") then
				inst.partner:PushEvent("stopmonsterfuck")
		    end
			inst.partner = nil 
		end)
	end
	if inst.components.locomotor then
	    if inst.afterfuckspeed_walk then
	        inst.components.locomotor.walkspeed = inst.afterfuckspeed_walk
	    end
	    if inst.afterfuckspeed_run then
	        inst.components.locomotor.runspeed = inst.afterfuckspeed_run
	    end
	end
	inst.components.health:SetInvincible(false)
	if inst.sg and inst.prefab ~= "lureplant" then
	    inst.sg:GoToState("idle")
	else
	    if inst.prefab ~= "lureplant" then
	        inst.AnimState:PlayAnimation("idle", true)
		else
		    inst:Show()
		end
	end
	inst:RestartBrain()
	end
end

local function EnterInFuck(inst)
	inst:AddTag("HavingSex")
	if inst.components.combat then
	    inst.components.combat.canattack = false
	end
	
    if inst:HasTag("FallOnFuckEnd") and inst.partner then
		inst.partner:AddTag("FallAfterFuck")
	elseif inst:HasTag("WakeupOnFuckEnd") and inst.partner then
	    inst.partner:AddTag("WakeupOnFuckEnd")
	end
	if inst.components.locomotor and inst.components.locomotor.runspeed ~= 0 then
	    inst.afterfuckspeed_walk = inst.components.locomotor.walkspeed
	    inst.afterfuckspeed_run = inst.components.locomotor.runspeed
	    inst.components.locomotor.runspeed = 0
	    inst.components.locomotor.walkspeed = 0
	end
	if inst.prefab ~= "hermitcrab" then
		if inst.sg and inst.prefab ~= "lureplant" then
		    inst.sg:GoToState("idle")
	    else
	        inst:Hide()
	    end
	end

	inst:StopBrain()
end

local function KillAllTaskInSex(inst)
    if inst:HasTag("HavingSex") and inst.prefab ~= "hermitcrab" then
	    if inst.components.combat then
		    inst.components.combat:SetTarget(nil)
		end
		
		if inst.prefab ~= "lureplant" then
		    inst.AnimState:PlayAnimation("inviz", true)
		else
		    inst:Hide()
		end
	end
end

local function MakeString(hero, victim, fucker)
    local str = ""
	if hero and victim and fucker then
	    if hero.prefab == "pigman" then
		    hero = hero:GetDisplayName().."(Pigman)" or "Unknown"
		else
		    hero = hero:GetDisplayName() or "Unknown"
		end
		victim = victim:GetDisplayName() or "Unknown"
	    if fucker.prefab == "pigman" then
		    fucker = fucker:GetDisplayName().."(Pigman)" or "Unknown"
		else
		    fucker = fucker:GetDisplayName() or "Unknown"
		end
		str = hero .. " saved " .. victim .. " from " .. fucker .. " rape"
	end
    return str
end

local function GetAttackWhenFucks(inst, data)
    if inst:HasTag("HavingSex") then
	    if data and data.attacker and inst.partner then
			GLOBAL.TheNet:AnnounceResurrect(MakeString(data.attacker, inst.partner, inst), inst.partner.entity)
	    end
	end
	ExitFuck(inst)
end

local function MonsterPerventCommon(inst)
    inst:AddTag("MALE")
	inst:AddTag("MONSTER_PERVERT")
	--inst:AddTag("sexable")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	if inst.intim_orgasmwait == nil then
		inst.intim_orgasmwait = 12
		inst.intim_orgasmsecondsleft = inst.intim_orgasmwait
	end
	if inst.intim_orgasmcount == nil then
		inst.intim_orgasmcount = 1
	end
	if inst.cumcolor == nil then
	    inst.cumcolor = {1, 1, 1, 1}
	end
	--inst:AddComponent("pervert")
	inst:AddComponent("sex")
	inst:ListenForEvent("EnterInFuck", EnterInFuck)
	inst:ListenForEvent("stopmonsterfuck", ExitFuck)
	inst:ListenForEvent("cum", Cum)
	inst:ListenForEvent("attacked", GetAttackWhenFucks)
	inst:ListenForEvent("onremove", OnRemoveDeath)
	inst:ListenForEvent("death", OnRemoveDeath)
	
	inst:DoPeriodicTask(1, OrgasmicCheck)
	inst:DoPeriodicTask(0, KillAllTaskInSex)
	inst:DoPeriodicTask(0.7, function()
	    if inst:HasTag("HavingSex") then
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_splat", nil, 0.23)
		end
	end)
end

local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

local function SpiderTrappable(inst)
	inst:AddTag("invsexable")
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    -- inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.nobounce = true
    -- inst.components.inventoryitem.canbepickedup = false
    -- inst.components.inventoryitem.canbepickedupalive = true
    -- inst.replica.inventoryitem:SetImage("inv_spider")
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/inv_spider.xml"
	inst:AddComponent("playtoy")
	-- if inst.components.health then
	    -- inst.components.health.canmurder = false
	-- end
	inst.friendlyfuck = "player_fuck_spider"
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end

AddPrefabPostInit("spider", function(inst)
    inst.swapbuildname = "spider_build"
	inst.fuckonkillstate = "spider_fuck_player"
	inst.fucktoystate = "fuck_spider"
	MonsterPerventCommon(inst)
	SpiderTrappable(inst)
	inst:AddTag("FUCKABLESPIDER")
	inst:AddTag("WakeupOnFuckEnd")
end)
AddPrefabPostInit("spider_warrior", function(inst)
    inst.swapbuildname = "spider_warrior_build"
	inst.fuckonkillstate = "spider_fuck_player"
	inst.fucktoystate = "fuck_spider"
	MonsterPerventCommon(inst)
	SpiderTrappable(inst)
	inst:AddTag("FUCKABLESPIDER")
	inst:AddTag("WakeupOnFuckEnd")
end)
AddPrefabPostInit("spider_dropper", function(inst)
    inst.swapbuildname = "spider_white"
	inst.fuckonkillstate = "spider_fuck_player"
	inst.fucktoystate = "fuck_spider"
	MonsterPerventCommon(inst)
	SpiderTrappable(inst)
	inst:AddTag("FUCKABLESPIDER")
	inst:AddTag("WakeupOnFuckEnd")
end)
AddPrefabPostInit("tentacle", function(inst)
    inst.swapbuildname = "tentacle"
	inst.fuckonkillstate = "tentacle_fuck_player"
	inst.friendlyfuck = "tentacle_fuck_player_wurt"
	
	inst.cumcolor = RGB(178, 0, 250)
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	inst:AddTag("FallOnFuckEnd")
end)
AddPrefabPostInit("tentacle_pillar_arm", function(inst)
    inst.swapbuildname = "tentacle_arm_build"
	inst.fuckonkillstate = "tinytentacle_fuck_player"
	inst.cumcolor = RGB(178, 0, 250)
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	inst:AddTag("WakeupOnFuckEnd")
end)
AddPrefabPostInit("wormla_vine", function(inst)
    inst.swapbuildname = "wormla_vine"
	inst.friendlyfuck = "player_fuck_tentacle"
	inst.cumcolor = RGB(83, 255, 61)
	MonsterPerventCommon(inst)
	inst:AddTag("sexable")
	inst:AddTag("FUCKABLETENTACLE")
	inst:AddTag("FallOnFuckEnd")
end)
AddPrefabPostInit("bunnyman", function(inst)
    inst.swapbuildname = "manrabbit_build"
	inst.fuckonkillstate = "bunny_fuck_player"
	inst.friendlyfuck = "player_fuck_bunny"
	inst.dick = "bunny_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)
AddPrefabPostInit("slurper", function(inst)
    inst.swapbuildname = "slurper_basic"
	inst.fuckonkillstate = "slurper_fuck_player"
	inst.friendlyfuck = "player_fuck_slurper"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)
AddPrefabPostInit("glommer", function(inst)
    inst.swapbuildname = "glommer"
	inst.friendlyfuck = "player_fuck_glommer"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	inst:AddTag("sexable")
	inst.cumcolor = RGB(178, 0, 250)
end)

AddPrefabPostInit("shadowpuddle", function(inst)
	inst.fuckonkillstate = "darkness_fuck_player"
	inst.friendlyfuck = "player_fuck_darkness"
	MonsterPerventCommon(inst)
	inst.cumcolor = RGB(0, 0, 0)
	inst:AddTag("FallOnFuckEnd")
end)

AddPrefabPostInit("cookiecutter", function(inst)
    inst.swapbuildname = "cookiecutter_build_rename"
	inst.fuckonkillstate = "cookie_fuck_player"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)
end)

local function ShouldAcceptItem(inst, item)
    if item.prefab == "monsterlasagna" then
        return true
	else
	    return false
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if inst.components.combat:TargetIs(giver) then
	    inst.components.combat:SetTarget(nil)
	end
	
	if giver.groom ~= nil then
	    return false
	end
	
    if giver.components.leader ~= nil then
	    inst.components.groom.pending_owner = giver
	    inst.components.groom.foodgoal = true
	    inst.components.groom.nakedgoal = true
	    inst.components.groom.sexgoal = true
		inst.components.groom:GoalsChanged()
    end
end

AddPrefabPostInit("spiderqueen", function(inst) 
    -- Reskin
    inst.AnimState:SetBank("spiderslut")
    inst.AnimState:SetBuild("spiderslut")
	--
    inst.swapbuildname = "spiderslut"
	inst.fuckonkillstate = "spiderslut_fuck_player"
	inst.friendlyfuck = "player_fuck_spiderslut"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)	
	
	inst:AddTag("NoGoals")
	inst:AddTag("NoBoost")
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst:AddComponent("follower")
	inst.components.follower:KeepLeaderOnAttacked()
	inst.components.follower.maxfollowtime = nil
	inst.components.follower.targettime = nil
	inst.components.follower.keepdeadleader = true
	
	inst:AddComponent("groom")
	
	inst.components.groom.noboost = true
	inst.components.groom.lovefxsymbol = "body"


    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)

AddPrefabPostInit("tallbird", function(inst)
    inst.AnimState:SetBuild("stockingsbird")
end)

AddPrefabPostInit("crawlinghorror", function(inst)
    inst.swapbuildname = "nightmare1_alpha"
	inst.fuckonkillstate = "nightmare1_fuck_player"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)
end)

AddPrefabPostInit("hound", function(inst)
    inst.swapbuildname = "hound"
	inst.fuckonkillstate = "hound_fuck_player"
	inst.dick = "wortox_dick"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)
end)

AddPrefabPostInit("firehound", function(inst)
    inst.swapbuildname = "hound_red"
	inst.fuckonkillstate = "hound_fuck_player"
	inst.dick = "wortox_dick"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)
end)

AddPrefabPostInit("icehound", function(inst)
    inst.swapbuildname = "hound_ice"
	inst.fuckonkillstate = "hound_fuck_player"
	inst.dick = "wortox_dick"
	inst:AddTag("FUCKABLETENTACLE")
	MonsterPerventCommon(inst)
end)

local function OnHitOther(inst, other, damage)
    if other:HasTag("player") then
	    if inst.minionlord then
		    local lur = inst.minionlord
			local player = other
			lur.components.sex:MonsterFuckPlayer(lur, player, damage)
		end
	end
end

AddPrefabPostInit("eyeplant", function(inst)
	inst:AddTag("MONSTER_PERVERT")

	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

AddPrefabPostInit("lureplant", function(inst)
    inst.swapbuildname = "eyeplant_trap"
	inst.fuckonkillstate = "lureplant_fuck_player"
	inst.friendlyfuck = "player_fuck_lureplant"
	inst.cumcolor = RGB(83, 255, 61)
	inst:AddTag("FUCKABLETENTACLE")
	inst:AddTag("plantfuck")
	MonsterPerventCommon(inst)
end)

local function NakedAround(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	local nudes = GLOBAL.TheSim:FindEntities(x,y,z,6) 
	
	for k,obj in pairs(nudes) do
	    if obj ~= inst and obj ~= inst.partner and obj.components.naked and 
		((inst:HasTag("pig") and not obj:HasTag("monster") and not obj:HasTag("merm")) 
		or (inst:HasTag("merm") and obj:HasTag("merm"))) then	
			if obj.components.naked:IsNaked("body") or obj.components.naked:IsNaked("legs") then -- Naked +2
			    return obj
			end
			if obj.sg:HasStateTag("fuck") or obj.sg:HasStateTag("suck") then -- Have Sex +3*2 cause two players will be seen.
			    return obj
            elseif obj.sg:HasStateTag("fap") then -- Someone fap +3
                return obj	
			end
		end
    end	

	return nil
end

local function GroomFn(inst)
	if inst.cumforrest <= 0 then
	    inst.cumrestoretime = inst.cumrestoretime-2
    end
    if inst.cumrestoretime <= 0 then
		inst.cumrestoretime = 240
		inst.cumforrest = 5
    end
		 
    if not inst:HasTag("werepig") and not inst:HasTag("guard") and (inst.sg:HasStateTag("idle") or inst.sg:HasStateTag("moving") or inst.sg:HasStateTag("fap")) then
		local nudes = NakedAround(inst)
		if not inst.sg:HasStateTag("fap") and nudes ~= nil and inst.cumforrest > 0 then
            inst.sg:GoToState("fap")
		elseif inst.sg:HasStateTag("fap") and (nudes == nil or inst.cumforrest <= 0) then
			if nudes ~= nil and inst.cumforrest <= 0 then
			    inst:PushEvent("CummedOnNude", { wife = nudes })
		    end
			inst.sg:GoToState("idle")
		end
	end
end

AddPrefabPostInit("merm", function(inst)
    inst.swapbuildname = "merm_build"
	inst.fuckonkillstate = "merm_fuck_player"
	inst.friendlyfuck = "player_fuck_merm"
	inst.dick = "merm_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	inst.cumforrest = 5
	inst.cumrestoretime = 240
	
	inst:AddComponent("groom")
	
	inst:DoPeriodicTask(2, GroomFn)
	
	inst.AnimState:OverrideSymbol("pig_torso", "merm_torso_dick", "pig_torso") 
	
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)

AddPrefabPostInit("catcoon", function(inst)
    inst.swapbuildname = "catcoon_build"
	inst.fuckonkillstate = "catcoon_fuck_player"
	inst.friendlyfuck = "player_fuck_catcoon"
	inst.dick = "wortox_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)

local function PigTypeBuild(inst)
	inst.fuckonkillstate = "merm_fuck_player"
	inst.friendlyfuck = "player_fuck_merm"
	inst.dick = "pig_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	inst.cumforrest = 5
	inst.cumrestoretime = 240
	
    inst:DoPeriodicTask(2, GroomFn)
	
	inst:AddComponent("groom")
	
	inst:DoTaskInTime(1, function()
	    if not inst:HasTag("werepig") and not inst:HasTag("guard") then
		    --inst:AddComponent("groom")
	        if inst.build == "pig_build" then
		        inst.AnimState:OverrideSymbol("pig_torso", "pigman_torso_dick", "pig_torso")		    
		    else
	            inst.AnimState:OverrideSymbol("pig_torso", "pigman_torso_dick_dark", "pig_torso") 
		    end
	    end
	end)
	
    inst:DoPeriodicTask(0, function()
	    if inst:HasTag("werepig") then
		    inst.swapbuildname = "werepig_build"
		elseif inst:HasTag("guard") then
		    inst.swapbuildname = "pig_guard_build"
		else
		    inst.swapbuildname = "pig_build"
		end
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end

AddPrefabPostInit("pigman", PigTypeBuild)
AddPrefabPostInit("moonpig", PigTypeBuild)
AddPrefabPostInit("pigguard", PigTypeBuild)

AddPrefabPostInit("merm", function(inst)
    inst.swapbuildname = "merm_build"
	inst.fuckonkillstate = "merm_fuck_player"
	inst.friendlyfuck = "player_fuck_merm"
	inst.dick = "merm_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	inst.cumforrest = 5
	inst.cumrestoretime = 240
	
	inst:AddComponent("groom")
	
	inst:DoPeriodicTask(2, GroomFn)
	
	inst.AnimState:OverrideSymbol("pig_torso", "merm_torso_dick", "pig_torso") 
	
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)

AddPrefabPostInit("catcoon", function(inst)
    inst.swapbuildname = "catcoon_build"
	inst.fuckonkillstate = "catcoon_fuck_player"
	inst.friendlyfuck = "player_fuck_catcoon"
	inst.dick = "wortox_dick"
	MonsterPerventCommon(inst)
	inst:AddTag("FUCKABLETENTACLE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
    inst:DoPeriodicTask(0, function()
		if inst.components.follower and inst.components.follower.leader ~= nil then
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
		end
	end)
end)

local function Hermit(inst)
	MonsterPerventCommon(inst)
	inst:RemoveTag("MONSTER_PERVERT")
	inst:RemoveTag("MALE")
	
	inst:AddTag("PLAYERALIKE")
	inst:AddTag("sexable")
	inst:AddTag("FEMALE")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("naked")
	inst:AddComponent("cumattachable")
end

AddPrefabPostInit("hermitcrab", Hermit)