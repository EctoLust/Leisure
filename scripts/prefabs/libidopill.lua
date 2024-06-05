local assets =
{
    Asset("ANIM", "anim/libidopill.zip"),
	Asset("IMAGE", "images/inventoryimages/libidopill.tex"),
	Asset("ATLAS", "images/inventoryimages/libidopill.xml"),
}
local prefabs =
{

}

local function OnUse(inst, user)
    user.components.excited.libido = 100
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("libidopill")
    inst.AnimState:SetBuild("libidopill")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("libidopill")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/libidopill.xml"	
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnUse)
	
    return inst
end

return Prefab("libidopill", fn, assets)
