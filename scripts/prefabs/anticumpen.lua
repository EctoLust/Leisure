local assets =
{
    Asset("ANIM", "anim/anticumpen.zip"),
	Asset("IMAGE", "images/inventoryimages/anticumpen.tex"),
	Asset("ATLAS", "images/inventoryimages/anticumpen.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function OnUse(inst, user)
	user.anticumday = user.anticumday+3 
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("anticumpen")
    inst.AnimState:SetBuild("anticumpen")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("anticumpen")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/anticumpen.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM	
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	
    return inst
end

return Prefab("anticumpen", fn, assets)