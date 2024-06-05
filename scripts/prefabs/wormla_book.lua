local assets =
{
    Asset("ANIM", "anim/wormla_book.zip"),
	Asset("IMAGE", "images/inventoryimages/wormla_book.tex"),
	Asset("ATLAS", "images/inventoryimages/wormla_book.xml"),
}
local prefabs =
{

}

local function GiveMeNearPosePlz(inst, dst, randomval)
    local savetruedst = dst
	if randomval then
       dst = math.random(15,dst)
	end
	
	local heading_angle = inst.Transform:GetRotation()

    local object_heading_angle = heading_angle + 90-45 + 90*math.random()

    if math.random()<0.5 then
        object_heading_angle = heading_angle - 90+45 - 90*math.random()
    end

    local dir_object = Vector3(math.cos(object_heading_angle*DEGREES),0, math.sin(object_heading_angle*DEGREES))
    local x,y,z = inst.Transform:GetWorldPosition()
    local dist = dst + 0.2*dst*math.random()
    local posedata = {x - dist*dir_object.x, 0, z - dist*dir_object.z}
	return posedata
end

local function OnUse(inst, user)    
    local posedata = GiveMeNearPosePlz(inst, 3, false)
	local tentacle = SpawnPrefab("wormla_vine")
	tentacle.Transform:SetPosition(posedata[1], posedata[2], posedata[3])
	tentacle.sg:GoToState("attack_pre")
	inst:RemoveComponent("simpleread")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(50)
    inst.components.finiteuses:SetUses(0)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)	

    inst.AnimState:SetBank("wormla_book")
    inst.AnimState:SetBuild("wormla_book")
    inst.AnimState:PlayAnimation("idle")
	
	local size = 2.5
	inst.Transform:SetScale(size,size,size)

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("wormla_book")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wormla_book.xml"	
	
	inst:AddComponent("simpleread")
	inst.components.simpleread.brackable = false
    inst.components.simpleread.onused = OnUse
	
	inst:DoPeriodicTask(1, function()
	    if inst.components.finiteuses then	    
			if inst.components.finiteuses.current < 50 then
                inst.components.finiteuses:SetUses(inst.components.finiteuses.current+1)
			else
			    inst:RemoveComponent("finiteuses")
	            inst:AddComponent("simpleread")
	            inst.components.simpleread.brackable = false
                inst.components.simpleread.onused = OnUse				
			end
		end
	end)
	
    return inst
end

return Prefab("wormla_book", fn, assets)