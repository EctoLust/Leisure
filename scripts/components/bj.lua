local Bj = Class(function(self, inst)
    self.inst = inst
end)

local function MakeFuckBar(player, mode)
	if mode == nil then
	    mode = "Death"
	end
	local bar = SpawnPrefab("fuckbar")
	if bar and player then
	    bar.myplayer = player
		bar.mode = mode
		player.fuckbar = bar
		bar.Transform:SetPosition(player.Transform:GetWorldPosition())
		bar.Transform:SetPosition(bar:GetPosition().x,4,bar:GetPosition().z)
		if mode ~= "Death" then
		    bar.AnimState:SetPercent("fill_progress", 0)
		end
	end
end


local function TryDoWithPartner(stander, sucker, me, lewdtype, swap) -- (Человек сверху, Человек снизу, роль тебя в этом, тип) 
	if stander and sucker and (stander.sg:HasStateTag("idle") or swap) and stander:GetDistanceSqToInst(sucker) < 7 then
        if swap then
		    sucker.poseswap = true
		    stander.poseswap = true	
		end
		sucker.bj_oldxy = {sucker.Transform:GetWorldPosition()}
		stander.bj_oldxy = {stander.Transform:GetWorldPosition()}
	    MakeCharacterPhysics(sucker, 0, 0)
		MakeCharacterPhysics(stander, 0, 0)
		sucker.Transform:SetPosition(stander.Transform:GetWorldPosition())
		if lewdtype == "bj" then
		    stander.sg:GoToState("suckenjoy_state")
		    if me == "licker" then
		        sucker.sg:GoToState("lick_state") -- Лижем НЕ СОСЁМ
		    elseif me == "sucker" then
		        sucker.sg:GoToState("suck_state") -- Сосём НЕ ЛИЖЕМ
		    end
		end
		sucker.partner = stander -- линк на партнёра
		stander.partner = sucker -- тоже самое
        stander.AnimState:SetLayer(LAYER_BACKGROUND)
		stander.components.cumattachable:ChangeLayer(LAYER_BACKGROUND)
        stander.AnimState:SetSortOrder(5)
		if stander:HasTag("CHARLIEBITCH") then
		    MakeFuckBar(sucker, "Charlie")
		end
	elseif stander:GetDistanceSqToInst(sucker) > 7 then
	    stander.components.talker:Say("Ah...you so far..")
	elseif stander == nil or sucker == nil then
	    stander.components.talker:Say("...")
	elseif not stander.sg:HasStateTag("idle") then
	    sucker.components.talker:Say("You so busy do it?....oh..okay")
	elseif not sucker.sg:HasStateTag("idle") then
	    stander.components.talker:Say("You so busy do it?....oh..okay")
	end
end

function Bj:SuckOff(inst, target, swap)
    local gender = inst.intim_gender
	local targetgender = target.intim_gender
    if targetgender == "MALE" or targetgender == "ROBOT" then
	    TryDoWithPartner(target, inst, "sucker", "bj", swap)
	elseif targetgender == "FEMALE" then
	    TryDoWithPartner(target, inst, "licker", "bj", swap)
    end   
	return true
end

function Bj:Fap(inst)
    inst.sg:GoToState("fap_state")
	--inst.sg:GoToState("flipfuck_girl")
	return true
end

return Bj