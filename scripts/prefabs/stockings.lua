local assets =
{
    Asset("ANIM", "anim/stockings_pink.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_pink.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_pink.xml"),
	Asset("ANIM", "anim/stockings_purple.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_purple.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_purple.xml"),
	Asset("ANIM", "anim/stockings_red.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_red.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_red.xml"),
	Asset("ANIM", "anim/stockings_black.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_black.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_black.xml"),
	Asset("ANIM", "anim/stockings_shortblack.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_shortblack.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_shortblack.xml"),
	Asset("ANIM", "anim/stockings_pants.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_pants.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_pants.xml"),
	Asset("ANIM", "anim/stockings_shortblue.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_shortblue.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_shortblue.xml"),
	Asset("ANIM", "anim/stockings_shortpink.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_shortpink.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_shortpink.xml"),
	Asset("ANIM", "anim/stockings_playful.zip"),
	Asset("IMAGE", "images/inventoryimages/stockings_playful.tex"),
	Asset("ATLAS", "images/inventoryimages/stockings_playful.xml"),
}
local prefabs =
{

}

local function fn(pref, longtype)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank(pref)
    inst.AnimState:SetBuild(pref)
    inst.AnimState:PlayAnimation("idle")
	
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

	inst:AddTag("stockings")

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("named")
	inst:AddComponent("skinner")
	
	if longtype == 1 then
	    inst.components.named:SetName("Stockings")	
	elseif longtype == 2 then
	    inst.components.named:SetName("Socks")
	elseif longtype == 3 then
	    inst.components.named:SetName("Short stockings")
	end
	inst.components.inspectable:SetDescription("Looks sexy.")
	
	inst:AddComponent("puton")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.replica.inventoryitem:SetImage(pref)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..pref..".xml"
	
    return inst
end

local function stockings_pink() return fn("stockings_pink",1) end
local function stockings_purple() return fn("stockings_purple",1) end
local function stockings_red() return fn("stockings_red",1) end
local function stockings_black() return fn("stockings_black",1) end
local function stockings_playful() return fn("stockings_playful",1) end
local function stockings_shortblack() return fn("stockings_shortblack",2) end
local function stockings_shortblue() return fn("stockings_shortblue",3) end
local function stockings_shortpink() return fn("stockings_shortpink",3) end
local function stockings_pants() return fn("stockings_pants",1) end

return Prefab("stockings_pink", stockings_pink, assets),
Prefab("stockings_purple", stockings_purple, assets),
Prefab("stockings_red", stockings_red, assets),
Prefab("stockings_black", stockings_black, assets),
Prefab("stockings_playful", stockings_playful, assets),
Prefab("stockings_shortblack", stockings_shortblack, assets),
Prefab("stockings_shortblue", stockings_shortblue, assets),
Prefab("stockings_shortpink", stockings_shortpink, assets),
Prefab("stockings_pants", stockings_pants, assets)