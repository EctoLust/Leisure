local assets =
{
    Asset("ANIM", "anim/lewd_cen.zip"),
}

local function Pin(inst)
    local owner = inst.owner
	inst.entity:SetParent(owner.entity) 
    inst.entity:AddFollower()		
    inst.Follower:FollowSymbol(owner.GUID, inst.pin_sym, inst.pin_x, inst.pin_y, 0)	 
	--printwrap("", getmetatable(inst.Follower).__index)
    if owner.censors == nil then
	    owner.censors = {}
    end	
	table.insert(owner.censors, inst)
end

local function fn()
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local sound = inst.entity:AddSoundEmitter()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst:AddTag("NOCLICK")
	
    inst.AnimState:SetBuild("lewd_cen")
    inst.AnimState:SetBank("lewd_cen")
	inst.AnimState:PlayAnimation("anim2", false)
	inst.AnimState:SetFinalOffset(3)	
	
    inst.entity:SetPristine()
	
	inst.Transform:SetNoFaced(inst)
	--inst.Transform:SetFourFaced()
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("Pin", Pin)
   
	return inst
end

return Prefab("censor", fn, assets, prefabs)