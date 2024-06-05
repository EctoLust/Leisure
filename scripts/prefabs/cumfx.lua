local assets =
{
    Asset("ANIM", "anim/splash.zip"),
}
local prefabs =
{

}

local function onfinished(inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("splash")
    inst.AnimState:SetBuild("splash")
    inst.AnimState:PlayAnimation("splash")
	
	inst.AnimState:SetFinalOffset(1)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/frog/splash")
	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

return Prefab("cumfx", fn, assets)
