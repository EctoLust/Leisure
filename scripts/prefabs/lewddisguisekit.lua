local assets =
{
    Asset("ANIM", "anim/lewddisguisekit.zip"),
	Asset("IMAGE", "images/inventoryimages/lewddisguisekit.tex"),
	Asset("ATLAS", "images/inventoryimages/lewddisguisekit.xml"),
}

local function OnUse(inst, user)
    user.lewddisguisekit_client:push()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("lewddisguisekit")
    inst.AnimState:SetBuild("lewddisguisekit")
    inst.AnimState:PlayAnimation("idle")
	
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("lewddisguisekit")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lewddisguisekit.xml"	
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	inst.components.simpleuse.brackable = false
	
    return inst
end

return Prefab("lewddisguisekit", fn, assets)
