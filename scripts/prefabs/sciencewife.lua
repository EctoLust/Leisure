local assets =
{
    Asset("ANIM", "anim/sciencewife.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function destoryit(inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.AnimState:SetBank("sciencewife")
    inst.AnimState:SetBuild("sciencewife")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(destoryit)
	 
    return inst
end

return Prefab("sciencewife", fn, assets, prefabs),
       MakePlacer("sciencewife_placer", "sciencewife", "sciencewife", "anim" )
