local assets =
{
    Asset("ANIM", "anim/dropedclothing.zip"),
}
local prefabs =
{

}
--ThePlayer.components.naked:TakeOffClothing("legs")
--ThePlayer.sg:GoToState("takeoff_legs")
--print(ThePlayer.components.naked.legs_nude)
local function onpickedfn(inst, picker)
    if picker.components.naked then
        picker.components.naked:PutOnClothing(inst.type, inst.savedname)
		picker.sg:GoToState("puton_"..inst.type)
	    inst:Remove()
	else
	    if picker.components.talker then
	        picker.components.talker:Say("This dirty, will not pickup it.")
			inst.components.pickable.canbepicked = true
		end
	end
end

local function OnSave(inst, data)
    if data then 
	    if inst.ku then
	        data.ku = inst.ku
	    end
		if inst.type then
		    data.type = inst.type
		end
		if inst.savedname then
		    data.savedname = inst.savedname
		end
	end
end

local function OnLoad(inst, data)
    if data then 
	    if data.ku then
	        inst.ku = data.ku
	    end
		if data.type then
		    inst.type = data.type
		end
		if data.savedname then
		    inst.savedname = data.savedname
		end
	end
end

local function fn(isbackground)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("dropedclothing")
    inst.AnimState:SetBuild("dropedclothing")
    inst.AnimState:PlayAnimation("")
	
	if isbackground then
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    end

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("named")
	inst:AddComponent("skinner")
	
	inst.components.named:SetName("Clothing")
	inst.components.inspectable:SetDescription("Someone take it off.")
    inst:AddComponent("pickable")
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
	inst.components.pickable.canbepicked = true
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, function()	
		 if inst.type then
		     inst.AnimState:PlayAnimation(inst.type)
			 if inst.savedname then
			     
			 end
		 end
	end)

    return inst
end

return Prefab("dropedclothing", fn, assets)
