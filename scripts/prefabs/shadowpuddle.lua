local assets =
{
    Asset("ANIM", "anim/ice_puddle.zip"),
}
local prefabs =
{

}


local function SlowlykKilling(inst)
    if inst.partner and not inst:HasTag("friendly") then
	    inst.partner.components.health:SetInvincible(false)
		inst.partner.components.health:DoDelta(-2, false, "shadowpuddle")
	end
end

local function OnCollide(inst, colider)
    if not inst:HasTag("cooldownrape") and inst.partner == nil and colider:HasTag("player") and not colider:HasTag("playerghost") and not colider.components.health:IsDead() then
	    inst:AddTag("cooldownrape")
	    inst.components.named:SetName("Shadow hands")
	    inst.components.inspectable:SetDescription("OH GOD! NOOOO")	    
		inst.components.sex:MonsterFuckPlayer(inst, colider)
		local player = colider
		--player:ShowHUD(true)
		player.components.health:SetInvincible(false)
	end
end

local function GoAway(inst)
    inst:PushEvent("stopmonsterfuck")
	inst:DoTaskInTime(0, ErodeAway)
end

local function OnLoad(inst, data)
	inst:Remove()
end

local function SpecialVision(inst, bool)  
	if bool == true then
	    inst.AnimState:SetMultColour(0,49, 1, 0, 1)
	else
	    inst.AnimState:SetMultColour(0, 0, 0, 1)
	end
	
	inst.Light:Enable(bool)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddPhysics()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    local size = 0.7
    inst.AnimState:SetBank("ice_puddle")
    inst.AnimState:SetBuild("ice_puddle")
    inst.AnimState:PlayAnimation("full")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(0, 0, 0, 1)
    inst.Transform:SetScale(size,size,size)
	
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	MakeSmallObstaclePhysics(inst, 0.5)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("spawnfader")
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1)

    inst:AddComponent("combat")
	
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst:AddComponent("named")
	inst:AddComponent("inspectable")
	
	inst.components.named:SetName("Strange puddle")
	inst.components.inspectable:SetDescription("Looks..dark")
	
	inst.OnLoad = OnLoad
	
    
	inst:DoPeriodicTask(3, SlowlykKilling)
	
	inst:WatchWorldState("cycles", GoAway)
	
    return inst
end

return Prefab("shadowpuddle", fn, assets)
