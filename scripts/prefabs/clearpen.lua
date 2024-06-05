local assets =
{
    Asset("ANIM", "anim/clearpen.zip"),
	Asset("IMAGE", "images/inventoryimages/clearpen.tex"),
	Asset("ATLAS", "images/inventoryimages/clearpen.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function OnUse(inst, user)
	user.boobsresize = 0
	user.anticumday = 0
	user:PushEvent("RemoveBoobsEff")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("clearpen")
    inst.AnimState:SetBuild("clearpen")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("clearpen")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/clearpen.xml"	
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	
    return inst
end

return Prefab("clearpen", fn, assets)