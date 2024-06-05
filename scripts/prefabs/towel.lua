local assets =
{
    Asset("ANIM", "anim/fabric.zip"),
	Asset("IMAGE", "images/inventoryimages/towel.tex"),
	Asset("ATLAS", "images/inventoryimages/towel.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function OnUse(inst, user)
	user.lube = 0
	user.stickysalve = 0
	if user.components.moisture then
	    user.components.moisture:DoDelta(-5)
    end    
	if user.components.cumattachable then
	    user.components.cumattachable:RemoveCum()
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("fabric")
    inst.AnimState:SetBuild("fabric")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("towel")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/towel.xml"	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	
    return inst
end

return Prefab("towel", fn, assets)
