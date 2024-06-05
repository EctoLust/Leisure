local assets =
{
    Asset("ANIM", "anim/dildo_dick.zip"),
	Asset("IMAGE", "images/inventoryimages/strapon.tex"),
	Asset("ATLAS", "images/inventoryimages/strapon.xml"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function OnUse(inst, user)    
	if not user.components.naked:IsHasDick() then	
	    user.components.naked.dick = "strapon_dick"
	    user.AnimState:OverrideSymbol("dick", user.components.naked.dick, "dick")
	    user.components.naked.havedick = true
	    if user.components.talker then
		    user.components.talker:Say("Good! Now I can use it in sex!")
	    end
		user:AddTag("HaveDick")
		user.dildo_client:set(true)
		user.components.naked:TakeOffClothing("")
	else
	    user.components.talker:Say("I has born with dick! What for in need it?")
		user.components.lootdropper:SpawnLootPrefab("strapon")
	end	
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("dildo_dick")
    inst.AnimState:SetBuild("dildo_dick")
    inst.AnimState:PlayAnimation("idle")
	
	local size = 2.3
	inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("strapon")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/strapon.xml"	
	
	inst:AddComponent("simpleuse")
    inst.components.simpleuse.onused = OnUse
	
    return inst
end

return Prefab("strapon", fn, assets)