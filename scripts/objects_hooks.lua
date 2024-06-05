--splash_spiderweb
local function OnRemoveDeath(inst)
    if inst.partner then
        inst.partner:DoTaskInTime(0.1, 
		function()
		    if inst.partner and inst.partner.sg:HasStateTag("fuck") then
				inst.partner:PushEvent("stopmonsterfuck")
		    end
			inst.partner = nil 
		end)
	end
end

local function ExitFuck(inst)
    inst:RemoveTag("HavingSex")
    if inst.partner then
        inst:DoTaskInTime(0.1, 
		function()
		    if inst.partner and inst.partner.sg:HasStateTag("fuck") then
				inst.partner:PushEvent("stopmonsterfuck")
		    end
			inst.partner = nil 
		end)
	end
	inst:Show()
end

local function EnterInFuck(inst)
	inst:AddTag("HavingSex")
	inst:Hide()
end

local function ObjectPerventCommon(inst)
    inst:AddTag("MALE")
	inst:AddTag("MONSTER_OBJECT")
	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("sex")
	inst:ListenForEvent("EnterInFuck", EnterInFuck)
	inst:ListenForEvent("stopmonsterfuck", ExitFuck)
	inst:ListenForEvent("onremove", OnRemoveDeath)
	inst:ListenForEvent("death", OnRemoveDeath)
	
	inst:DoPeriodicTask(0.7, function()
	    if inst:HasTag("HavingSex") then
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentacle_splat", nil, 0.23)
		end
	end)
end

local function MushroomCommon(inst)
	local size = 0.5
	inst.Transform:SetScale(size,size,size)	
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end	

    inst:DoPeriodicTask(0, function()
	    if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then    
		    inst:AddTag("sexable")
		else
		    inst:RemoveTag("sexable")
	    end
	end)
end

AddPrefabPostInit("red_mushroom", function(inst)
    MushroomCommon(inst)
	ObjectPerventCommon(inst)
	inst.swapbuildname = "mushrooms"
	inst.friendlyfuck = "mushroom_red"
	inst:AddTag("FUCKOBJECT")
end)
AddPrefabPostInit("green_mushroom", function(inst)
    MushroomCommon(inst)
	ObjectPerventCommon(inst)
	inst.swapbuildname = "mushrooms"
	inst.friendlyfuck = "mushroom_green"
	inst:AddTag("FUCKOBJECT")
end)
AddPrefabPostInit("blue_mushroom", function(inst)
    MushroomCommon(inst)
	ObjectPerventCommon(inst)
	inst.swapbuildname = "mushrooms"
	inst.friendlyfuck = "mushroom_blue"
	inst:AddTag("FUCKOBJECT")
end)

