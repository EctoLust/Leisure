local assets =
{
    Asset("ANIM", "anim/dropedclothing.zip"),
	Asset("ANIM", "anim/droppedmask.zip"),
}
local prefabs =
{

}
--ThePlayer.components.naked:TakeOffClothing("legs")
--ThePlayer.sg:GoToState("takeoff_legs")
--print(ThePlayer.components.naked.legs_nude)
local function onpickedfn(inst, picker)
    if picker.components.naked then
		if not inst.disquiseitem then
			picker.components.naked:PutOnClothing(inst.type, inst.savedname)
		else
		    picker.components.naked:PutOnDisguise(inst.type, inst.savedname, inst.dick, inst.tits, inst.tint)
		end
		picker.sg:GoToState("puton_"..inst.type)
	    inst:Remove()
	else
	    if picker.components.talker then
	        picker.components.talker:Say("This dirty, won't pick it up.")
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
		if inst.disquiseitem ~= nil then
		    data.disquiseitem = inst.disquiseitem
		end
		if inst.dick ~= nil then
		    data.dick = inst.dick
		end
		if inst.tits ~= nil then
		    data.tits = inst.tits
		end
		if inst.tint ~= nil then
		    data.tint = inst.tint
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
		if data.disquiseitem ~= nil then
		    inst.disquiseitem = data.disquiseitem
		end
		if data.dick ~= nil then
		    inst.dick = data.dick
		end
		if data.tits ~= nil then
		    inst.tits = data.tits
		end
		if data.tint ~= nil then
		    inst.tint = data.tint
		end
	end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("dropedclothing")
    inst.AnimState:SetBuild("dropedclothing")
    inst.AnimState:PlayAnimation("")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

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
	inst.disquiseitem = false
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, function()	
		 if inst.type then
			if inst.disquiseitem == true and inst.savedname ~= nil then
			    if inst.tits ~= nil and inst.tits ~= "" then
				    inst.AnimState:SetBuild(inst.tits)
				else
				    inst.AnimState:SetBuild(inst.savedname)
				end
			end
			if inst.type == "head" then
	            inst.AnimState:SetBank("droppedmask")
			    local size = 0.7
			    inst.Transform:SetScale(size,size,size)	
                inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)				 
			end
			if inst.tint ~= nil then
			    inst.AnimState:SetMultColour(inst.tint.r, inst.tint.g, inst.tint.b, 1)	
			end
			inst.AnimState:PlayAnimation(inst.type)
		 end
	end)

    return inst
end

return Prefab("dropedclothing", fn, assets)
