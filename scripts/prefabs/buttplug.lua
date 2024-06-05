local assets =
{
    Asset("ANIM", "anim/buttplug.zip"),
	Asset("IMAGE", "images/inventoryimages/buttplug.tex"),
	Asset("ATLAS", "images/inventoryimages/buttplug.xml"),
	Asset("IMAGE", "images/inventoryimages/buttplug_blue.tex"),
	Asset("ATLAS", "images/inventoryimages/buttplug_blue.xml"),
	Asset("IMAGE", "images/inventoryimages/buttplug_red.tex"),
	Asset("ATLAS", "images/inventoryimages/buttplug_red.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function fn(inst, color, dur)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("buttplug")
    inst.AnimState:SetBuild("buttplug")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("plug")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("buttplug"..color)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/buttplug"..color..".xml"	
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(dur)
    inst.components.finiteuses:SetUses(dur)
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	
	if color == "_blue" then
        inst:AddComponent("heater")
        inst.components.heater:SetThermics(false, true)
        inst.components.heater.equippedheat = -12
	end
	if color == "_red" then
        inst:AddComponent("heater")
        inst.components.heater:SetThermics(true, false)
        inst.components.heater.equippedheat = 12	
	end
	
    return inst
end

local function buttplug()
    local inst = CreateEntity()
	return fn(inst, "", 20)
end
local function buttplug_blue()
    local inst = CreateEntity()
	return fn(inst, "_blue", 10)
end
local function buttplug_red()
    local inst = CreateEntity()
	return fn(inst, "_red", 10)
end

return Prefab("buttplug", buttplug, assets),
Prefab("buttplug_blue", buttplug_blue, assets),
Prefab("buttplug_red", buttplug_red, assets)