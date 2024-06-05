local assets =
{
    Asset("ANIM", "anim/cumnew.zip"),
}

--ThePlayer.AnimState:GetCurrentFacing()

--Down 3
--Up 1
--Left 2
--Right 0

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cumnew")
    inst.AnimState:SetBuild("cumnew")
    inst.AnimState:PlayAnimation("4_front")
	
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local num = math.random(7)
	inst.AnimState:PlayAnimation(num.."_floor")
	
	inst:DoTaskInTime(9, ErodeAway)
	
    return inst
end

return Prefab("cumfloor", fn, assets)
