local assets =
{
    Asset("ANIM", "anim/lewdlovefx.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("poison")
    inst.AnimState:SetBuild("lewdlovefx")
	inst.AnimState:PlayAnimation("level1_pre")
	inst.AnimState:PushAnimation("level1_loop", true)
	
	inst.AnimState:SetFinalOffset(1)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	--inst:ListenForEvent("animover", ErodeAway)
	
    return inst
end

return Prefab("lewdlovefx", fn, assets)