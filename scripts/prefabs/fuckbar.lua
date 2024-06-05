local assets = 
{
	
}

local function ChangeAnim(inst)
    if inst.myplayer then
	    inst.myplayer.fuckbar = inst
		if inst.proccentsleft > 0 then
		    inst.proccentsleft = inst.proccentsleft-0.0333333333333334
			inst.AnimState:SetPercent("fill_progress", inst.proccentsleft)
		end
		if inst.proccentsleft <= 0 then
		    if inst.myplayer and inst.myplayer.components.health then
                if not inst.myplayer:IsHUDVisible() then
                    inst.myplayer:ShowHUD(true)
                end			    
				inst.myplayer.components.health:SetInvincible(false)
				if inst.myplayer and inst.myplayer.partner then
			        inst.myplayer.components.health:DoDelta(-700, false, inst.myplayer.partner.prefab)
				end
				inst:Remove()
			end
		end
	else
	    inst:Remove()
	end
end

local function ChangeAnimInvert(inst)
    if inst.myplayer then
	    inst.myplayer.fuckbar = inst
		if inst.proccentsleft < 100 then
		    inst.proccentsleft = inst.proccentsleft+0.0333333333333334
			inst.AnimState:SetPercent("fill_progress", inst.proccentsleft)
		end
	else
	    inst:Remove()
	end
end

local function DmgOnFuck(inst)
    if TUNING.NO_RAPE_DAMAGE == 1 then
	     return
	end
	if inst.myplayer and inst.myplayer.partner then
	    inst.myplayer.components.health:SetInvincible(false)
		if inst.myplayer.fuckdamage and inst.proccentsleft < 1 and inst.antirape == nil then
		    inst.myplayer.components.health:DoDelta(-inst.myplayer.fuckdamage, false, inst.myplayer.partner.prefab)
		end
		local fuckspeed = 3 		 
		if inst.myplayer and inst.myplayer.stickysalve and inst.myplayer.stickysalve > 0 then
			fuckspeed = 8
			inst.myplayer.stickysalve = inst.myplayer.stickysalve-1
	    end	 
	    inst:DoTaskInTime(fuckspeed, DmgOnFuck)		
	else
	    inst:Remove()
	end
end

local function Avoid(inst)
    
	if inst.myplayer and inst.myplayer.partner and inst.myplayer.partner.prefab == "shadowpuddle" then
	    inst.proccentsleft = inst.proccentsleft+0.05
	else
	    inst.proccentsleft = inst.proccentsleft+0.13
	end
	inst.AnimState:SetPercent("fill_progress", inst.proccentsleft)
	if inst.proccentsleft >= 1 then
	    inst.myplayer:PushEvent("stopmonsterfuck")		
		inst:Remove()
	end
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
	
    inst.AnimState:SetBuild("player_progressbar_small")
    inst.AnimState:SetBank("player_progressbar_small")
	inst.AnimState:PlayAnimation("fill_progress", false)
	inst.AnimState:SetPercent("fill_progress", 0)
	inst.AnimState:SetFinalOffset(1)	
	
    inst.entity:SetPristine()
	
	local size = 2.5
	inst.Transform:SetScale(size,size,size)
	

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetMultColour(2, 1, 1, 1)
	
	inst.Transform:SetNoFaced(inst)
	
	inst.proccentsleft = 1
	
	inst:DoTaskInTime(1, function()
	     if inst.mode == "Death" then
	         inst.proccentsleft = 0
			 
			 local fuckspeed = 3 
			 
			 if inst.myplayer and inst.myplayer.stickysalve and inst.myplayer.stickysalve > 0 then
			     fuckspeed = 6
			 end
			 
			 inst:DoTaskInTime(fuckspeed, DmgOnFuck)
			 inst:ListenForEvent("Avoid", Avoid)
		 else
		     inst.proccentsleft = 0
		     inst:DoPeriodicTask(1, ChangeAnimInvert)
		 end
	end)
	
   
	return inst
end

return Prefab("common/fuckbar", fn, assets, prefabs)