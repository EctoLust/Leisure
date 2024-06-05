local assets =
{
    Asset("ANIM", "anim/nightmarefuel.zip"),
	Asset("IMAGE", "images/inventoryimages/shadowgoop.tex"),
	Asset("ATLAS", "images/inventoryimages/shadowgoop.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function OnUse(inst, user)
	local shadow = SpawnPrefab("shadowpuddle")
	shadow:AddTag("friendly")
	shadow.Transform:SetPosition(user.Transform:GetWorldPosition())
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("nightmarefuel")
    inst.AnimState:SetBuild("nightmarefuel")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, 0.5)

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("shadowgoop")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/shadowgoop.xml"	
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	inst.components.simpleuse.brackable = false
	
    return inst
end

return Prefab("shadowgoop", fn, assets)
