local assets =
{
    Asset("ANIM", "anim/plug_foxtail.zip"),
	Asset("IMAGE", "images/inventoryimages/plug_foxtail.tex"),
	Asset("ATLAS", "images/inventoryimages/plug_foxtail.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("tail", inst.prefab, "tail")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("tail")
end

local function fn(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("plugtail")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage(name)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"	
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    return inst
end

local function tail1() return fn("plug_foxtail") end

return Prefab("plug_foxtail", tail1, assets)
