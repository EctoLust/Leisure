local assets =
{
    Asset("ANIM", "anim/boobspen.zip"),
	Asset("IMAGE", "images/inventoryimages/boobspen.tex"),
	Asset("ATLAS", "images/inventoryimages/boobspen.xml"),
}
local prefabs =
{

}

local function OnUse(inst, user)
	
	if user.components.naked.nude_build == "" or user.prefabs == "walter" then
	    user.components.talker:Say("Hm...not seems to be work...sadly")
		user.components.lootdropper:SpawnLootPrefab("boobspen")
	    return false
	end
	
	user.boobsresize = user.boobsresize+2
	if user.components.naked then
	    user.components.naked:EnlargeTits(true)
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("boobspen")
    inst.AnimState:SetBuild("boobspen")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("boobspen")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/boobspen.xml"	
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	
    return inst
end

return Prefab("boobspen", fn, assets)