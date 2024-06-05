local assets =
{
    Asset("ANIM", "anim/sextalker.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
  
    inst:AddTag("character")
	
    inst.AnimState:SetBank("sextalker")
    inst.AnimState:SetBuild("sextalker")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0,0,0)
	--inst.components.talker:StopIgnoringAll()
	--inst.components.talker:MakeChatter()
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	
	if inst.components.talker then
	    inst.components.talker:Say("TEST")
	else
	    print("TALKER IS NIL!")
	end
	
    return inst
end

return Prefab("sextalker", fn, assets)
