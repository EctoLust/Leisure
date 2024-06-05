local assets =
{
    Asset("ANIM", "anim/stickysalve.zip"),
	Asset("IMAGE", "images/inventoryimages/stickysalve.tex"),
	Asset("ATLAS", "images/inventoryimages/stickysalve.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("stickysalve")
    inst.AnimState:SetBuild("stickysalve")
    inst.AnimState:PlayAnimation("idle")
	
	local size = 2.3
	inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("stickysalve")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stickysalve.xml"	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
	
	inst:AddComponent("lube")
    inst.components.lube.lubecount = 10
	inst.components.lube.sticky = true
	
    return inst
end

return Prefab("stickysalve", fn, assets)
