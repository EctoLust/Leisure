local assets =
{
    Asset("ANIM", "anim/tentacle.zip"),
	Asset("ANIM", "anim/wormla_vine.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
}

local prefabs =
{
    "monstermeat",
    "tentaclespike",
    "tentaclespots",
}

SetSharedLootTable( 'wormla_vine',
{
    {'petals',   1.0}
})

local function retargetfn(inst)
    return FindEntity(
        inst,
        5.2,
        function(guy) 
            return guy.prefab ~= inst.prefab
                and guy.entity:IsVisible()
                and not guy.components.health:IsDead()
				and not guy:HasTag("player")
        end,
        { "_combat", "_health" }, nil)
end

local function shouldKeepTarget(inst, target)
    return target ~= nil
        and target:IsValid()
        and target.entity:IsVisible()
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and target:IsNear(inst, 7)
end

local function OnAttacked(inst, data)
    if data.attacker == nil then
        return
    end

    local current_target = inst.components.combat.target

    if current_target == nil then
        --Don't want to handle initiating attacks here;
        --We only want to handle switching targets.
        return
    elseif current_target == data.attacker then
        --Already targeting our attacker, just update the time
        inst._last_attacker = current_target
        inst._last_attacked_time = GetTime()
        return
    end

    local time = GetTime()
    if inst._last_attacker == current_target and
        inst._last_attacked_time + 7 >= time then
        --Our target attacked us recently, stay on it!
        return
    end

    --Switch to new target
    inst.components.combat:SetTarget(data.attacker)
    inst._last_attacker = data.attacker
    inst._last_attacked_time = time
end

local function WorlmaNear(inst)
    local wormla = FindEntity(inst,3.4,
    function(guy) 
        return guy:HasTag("wormla")
    end,{ "wormla"}, nil)
		
	if wormla == nil then
        return false
	else
        return true
	end
end

local function ontimer(inst, data)
    if data.name == "extinguish" then
	    ErodeAway(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddPhysics()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Physics:SetCylinder(0.25, 2)

    inst.AnimState:SetBank("tentacle")
    inst.AnimState:SetBuild("wormla_vine")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetMultColour(0,1,0,1)	

    inst:AddTag("monster")    
    inst:AddTag("hostile")
    inst:AddTag("wet")
    inst:AddTag("WORM_DANGER")
	inst:AddTag("tentacle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._last_attacker = nil
    inst._last_attacked_time = nil

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(650)

    inst:AddComponent("combat")
    inst.components.combat:SetRange(5.2)
    inst.components.combat:SetDefaultDamage(37)
    inst.components.combat:SetAttackPeriod(TUNING.TENTACLE_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(0.7, retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)

    MakeLargeFreezableCharacter(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('petals')

    inst:SetStateGraph("SGvine")

    inst:ListenForEvent("attacked", OnAttacked)
	
	inst:DoTaskInTime(800, ErodeAway)
	
    inst:AddComponent("timer")
    inst.components.timer:StartTimer("extinguish", 800)
    inst:ListenForEvent("timerdone", ontimer)
	
	inst:DoPeriodicTask(1, function()
	     local wormlaner = WorlmaNear(inst)
		 local target = inst.components.combat.target
		 
		 if target ~= nil and inst.sg:HasStateTag("show") then
			 inst.components.combat:StartAttack()
			 inst.sg:GoToState("attack")
		     return false
		 elseif target ~= nil and wormlaner then
			 inst.components.combat:StartAttack()
			 inst.sg:GoToState("attack")		     
		 end
		 
		 if wormlaner and target == nil and inst.sg:HasStateTag("invisible") and not inst.sg:HasStateTag("show") then		 
			 inst.sg:GoToState("show")
		 elseif not wormlaner and inst.sg:HasStateTag("show") and not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("post") then	 
			 inst.sg:GoToState("attack_post")
		 end
	end)

    return inst
end

return Prefab("wormla_vine", fn, assets, prefabs)