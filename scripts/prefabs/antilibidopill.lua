local assets =
{
    Asset("ANIM", "anim/antilibidopill.zip"),
	Asset("IMAGE", "images/inventoryimages/antilibidopill.tex"),
	Asset("ATLAS", "images/inventoryimages/antilibidopill.xml"),
}
local prefabs =
{

}

local function OnUse(inst, user)
    user.components.excited.libido = 0
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("antilibidopill")
    inst.AnimState:SetBuild("antilibidopill")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("antilibidopill")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/antilibidopill.xml"	
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnUse)
	
    return inst
end

return Prefab("antilibidopill", fn, assets)
