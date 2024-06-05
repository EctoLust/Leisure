local assets =
{
    Asset("ANIM", "anim/plantjuice.zip"),
	Asset("IMAGE", "images/inventoryimages/plantjuice.tex"),
	Asset("ATLAS", "images/inventoryimages/plantjuice.xml"),
}
local prefabs =
{

}

local function OnUse(inst, user)
    if not user:HasTag("plantkin") then
        user:AddTag("plantkin")
	    user:DoTaskInTime(120, 
	    function()
	        user:RemoveTag("plantkin")
	    end)
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("plantjuice")
    inst.AnimState:SetBuild("plantjuice")
    inst.AnimState:PlayAnimation("idle")
	
	local size = 1
	inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("plantjuice")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/plantjuice.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.GOODIES
	inst.components.edible:SetOnEatenFn(OnUse)	
	
    return inst
end

return Prefab("plantjuice", fn, assets)
