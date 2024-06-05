local assets =
{
    Asset("ANIM", "anim/lustbook_item.zip"),
	Asset("IMAGE", "images/inventoryimages/lustbook_item.tex"),
	Asset("ATLAS", "images/inventoryimages/lustbook_item.xml"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("lustbook_item")
    inst.AnimState:SetBuild("lustbook_item")
    inst.AnimState:PlayAnimation("idle")
	
	--local size = 2.3
	--inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("lustbook_item")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lustbook_item.xml"	
	
	inst:AddComponent("lustbook")
	
    return inst
end

return Prefab("lustbook_item", fn, assets)
