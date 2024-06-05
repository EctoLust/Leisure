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

    inst.AnimState:SetBank("cumnew")
    inst.AnimState:SetBuild("cumnew")
    inst.AnimState:PlayAnimation("4_floor")
	
	inst.AnimState:SetFinalOffset(1)
	
	-- inst:DoPeriodicTask(0.5, function()
	    -- local player = FindEntity(inst, 2, function(item) return item:HasTag("player") end, nil, { "" })
        -- if player ~= nil then
		    -- --print("Found player")
			-- if player.AnimState:GetCurrentFacing() == 0 then
			    
			-- end
	    -- else
		    -- --print("Not found player")
        -- end		
	-- end)
	
	 
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local num = math.random(7)
	inst.AnimState:PlayAnimation(num.."_floor")
	
    return inst
end

return Prefab("cumnew", fn, assets)
