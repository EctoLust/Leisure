local assets =
{
    Asset("ANIM", "anim/lube.zip"),
	Asset("IMAGE", "images/inventoryimages/lube.tex"),
	Asset("ATLAS", "images/inventoryimages/lube.xml"),
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

    inst.AnimState:SetBank("lube")
    inst.AnimState:SetBuild("lube")
    inst.AnimState:PlayAnimation("idle")
	
	local size = 2.3
	inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("lube")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lube.xml"	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished) --Удаляем только если палатка полностью пуста.
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
	
	inst:AddComponent("lube")
    inst.components.lube.lubecount = 20
	
    return inst
end

return Prefab("lube", fn, assets)
