local assets =
{
	Asset("ANIM", "anim/ghostdolls.zip"),
	Asset("ANIM", "anim/dildo_dick.zip"),
	Asset("ANIM", "anim/dildo_dick_green.zip"),
	Asset("ANIM", "anim/dildo_dick_rainbow.zip"),
	Asset("ANIM", "anim/dildo_dick_red.zip"),
	Asset("ANIM", "anim/dildo_dick_yellow.zip"),
	Asset("ANIM", "anim/dildo_dick_gold.zip"),
	Asset("ANIM", "anim/vibrator_dick.zip"),
	Asset("ANIM", "anim/swap_abby_intim.zip"),
	Asset("ANIM", "anim/swap_fili_intim.zip"),
	Asset("ANIM", "anim/swap_ghost_intim.zip"),
	Asset("IMAGE", "images/inventoryimages/intim_abby_doll.tex"),
	Asset("ATLAS", "images/inventoryimages/intim_abby_doll.xml"),
	Asset("IMAGE", "images/inventoryimages/intim_ghost_doll.tex"),
	Asset("ATLAS", "images/inventoryimages/intim_ghost_doll.xml"),
	Asset("IMAGE", "images/inventoryimages/intim_fili_doll.tex"),
	Asset("ATLAS", "images/inventoryimages/intim_fili_doll.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo_green.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo_green.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo_rainbow.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo_rainbow.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo_red.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo_red.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo_gold.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo_gold.xml"),
	Asset("IMAGE", "images/inventoryimages/dildo_yellow.tex"),
	Asset("ATLAS", "images/inventoryimages/dildo_yellow.xml"),
	Asset("IMAGE", "images/inventoryimages/vibrator.tex"),
	Asset("ATLAS", "images/inventoryimages/vibrator.xml")	
}

local function abbyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ghostdolls")
    inst.AnimState:SetBank("ghostdolls")
    inst.AnimState:PlayAnimation("abby")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("playtoy")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("intim_abby_doll")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/intim_abby_doll.xml"
	
	inst.intimswap = "swap_abby_intim"

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

local function ghostfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ghostdolls")
    inst.AnimState:SetBank("ghostdolls")
    inst.AnimState:PlayAnimation("ghost")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("playtoy")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("intim_ghost_doll")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/intim_ghost_doll.xml"
	
	inst.intimswap = "swap_ghost_intim"

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

local function filifn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("ghostdolls")
    inst.AnimState:SetBank("ghostdolls")
    inst.AnimState:PlayAnimation("ghost")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("playtoy")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("intim_fili_doll")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/intim_fili_doll.xml"
	
	inst.intimswap = "swap_fili_intim"

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

local function PickupDildo(inst, owner)
    if inst.destorysoon then
	    inst.destorysoon = nil
	end
end

local function SetCommonDildo(inst, color)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("dildo_dick"..color)
	inst.AnimState:SetBuild("dildo_dick"..color)
    inst.AnimState:PlayAnimation("idle")
	
	MakeInventoryPhysics(inst)
	
	local size = 2.3
	inst.Transform:SetScale(size,size,size)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("playtoy")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("dildo"..color)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dildo"..color..".xml"
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst.dildo = true
	inst.intimswap = "dildo_dick"..color
	
	MakeHauntableLaunchAndSmash(inst)
	inst:ListenForEvent("onputininventory", PickupDildo)
end

local function vibrator()
    local inst = CreateEntity()	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("vibrator_dick")
	inst.AnimState:SetBuild("vibrator_dick")
    inst.AnimState:PlayAnimation("idle", true)
	
	MakeInventoryPhysics(inst)
	
	local size = 2.3
	inst.Transform:SetScale(size,size,size)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("playtoy")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("vibrator")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/vibrator.xml"
	
	inst.dildo = true
	inst.vibrator = true
	inst.intimswap = "vibrator_dick"
	
	MakeHauntableLaunchAndSmash(inst)
	
	return inst
end

local function dildo()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "")
    return inst
end
local function dildo_green()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "_green")
    return inst
end
local function dildo_red()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "_red")
    return inst
end
local function dildo_yellow()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "_yellow")
    return inst
end
local function dildo_rainbow()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "_rainbow")
    return inst
end
local function dildo_gold()
    local inst = CreateEntity()	
    SetCommonDildo(inst, "_gold")
    return inst
end

return Prefab("intim_abby_doll", abbyfn, assets),
Prefab("intim_ghost_doll", ghostfn, assets),
Prefab("intim_ghost_doll", ghostfn, assets),
Prefab("dildo", dildo, assets),
Prefab("dildo_green", dildo_green, assets),
Prefab("dildo_red", dildo_red, assets),
Prefab("dildo_yellow", dildo_yellow, assets),
Prefab("dildo_rainbow", dildo_rainbow, assets),
Prefab("dildo_gold", dildo_gold, assets),
Prefab("vibrator", vibrator, assets)