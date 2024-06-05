require "prefabutil"

local tent_assets =
{
    Asset("ANIM", "anim/tent.zip"),
}

local siestahut_assets =
{
    Asset("ANIM", "anim/siesta_canopy.zip"),
}

local function DoHurtSound(inst)
    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/hurt", nil, inst.hurtsoundvolume)
    end
end


local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
	if fx then
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if fx.SetMaterial then
			fx:SetMaterial("wood")
		else
			print("TENT ERROR: SetMaterial is nil")
		end
	end
    inst:Remove()
end

local ALL_PEOPLE = 0

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", true)
    end
    if inst.components.sleepingbag ~= nil then --and inst.components.sleepingbag.sleeper ~= nil then
        inst.components.sleepingbag:DoWakeUp(nil,ALL_PEOPLE) --���������� ���, � ������!
    end
end

local function onfinishedsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl")
end

local function onfinished(inst)
	local cnt = inst.components.sleepingbag:CountPlayers() --NB: ������ ��������. ���� ����������, �� ������� ����� ������.
    if not inst:HasTag("burnt") and cnt == 0 then
        inst.AnimState:PlayAnimation("destroy")
        inst:ListenForEvent("animover", inst.Remove)
        inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
        inst.persists = false --��, �� ���������
        inst:DoTaskInTime(16 * FRAMES, onfinishedsound)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end

local function onignite(inst)
	--�������� �� sleeper �������������� � ����� ����������. 
	--� ������ � ��� �� ����� ���� ���������, ��� ��� ������ ������ �� ������ � �����.
    inst.components.sleepingbag:DoWakeUp(nil,ALL_PEOPLE) --all
end


--We don't watch "stop'phase'" because that
--would not work in a clock without 'phase'
local function wakeuptest(inst, phase)
	if not inst.components.sleepingbag then
		print("TENT ERROR: fake wakeuptest "..tostring(inst).." "..tostring(phase))
		return --why???
	end
    if phase ~= inst.sleep_phase then
        inst.components.sleepingbag:DoWakeUp(nil,ALL_PEOPLE) --� ��-�� ������ ��� ����������! ���� �������.
    end
end


--Init sleepingbag (tuning)
do
	local sleepingbag = require "components/sleepingbag"
	--sleepingbag.players = {} --����... ������ ��� ������, ��������! ��� ������� �������� �����.
	
	--��������� ������� ���� ������� (��� �������� ����� ��������� ������)
	function sleepingbag:UpdateChances()
		local time_now = _G.GetTime()
		local cnt = #self.players
		for i=1,cnt do
			local sleeper = self.players[i]
			if not sleeper.pants_chance_sum then
				sleeper.pants_chance_sum = 0 --�� ������ ��������, ���� ��� ����� ������ ����.
			end
			if (cnt > 1) and (not sleeper.pants_chance_start_tm) then --����� �� ���������, � ���� (���� ����������)
				sleeper.pants_chance_start_tm = time_now
			elseif (cnt <= 1) and (sleeper.pants_chance_start_tm) then --����� �������, �� ���� ��� ����������
				--��������� � �����, ��� ������� ����.
				sleeper.pants_chance_sum = sleeper.pants_chance_sum + (time_now - sleeper.pants_chance_start_tm)
				sleeper.pants_chance_start_tm = nil --���������� �������
			elseif sleeper.pants_chance_start_tm then --���� �������, �� ������ ������������ ����� � �������� �����
				--���� ��� �� �����������, ������ ������.
				sleeper.pants_chance_sum = sleeper.pants_chance_sum + (time_now - sleeper.pants_chance_start_tm)
				sleeper.pants_chance_start_tm = time_now
			end
		end
	end
	
	--��������� ������� ������������� ������ � ������� (���������).
	function sleepingbag:CheckSleeper(sleeper)
		--print("--CheckSleeper "..tostring(self.inst)..", sleeper="..tostring(sleeper))
		for i=1,#self.players do
			if self.players[i] == sleeper then
				return sleeper, i
			end
		end
	end

	--��������� ��� ������ ������ � �������
	function sleepingbag:AddSleeper(sleeper)
		--print("----AddSleeper "..tostring(self.inst)..", sleeper="..tostring(sleeper))
		if self:CheckSleeper(sleeper) then --debug
			print("TENT ERROR: player already in tent!!! - "..tostring(sleeper))
			return
		end
		--� ������ ���������� ����� ��������� ���� ��������� �� ������� ����������, � �� ���� ��.
		for i=#self.players,1,-1 do
			if not self.players[i]:IsValid() then
				table.remove(self.players,i) --������ �����������, ������ ��� ������ ������ ��� �� ����.
			end
		end
		--���� ����������
		table.insert(self.players,sleeper)
		sleeper.pants_chance_sum = 0 --�������� ����� ��� ��������� � �������.
		--����� ���������� ����������� ��� ����� � ������� ���� ���������� �������
		self:UpdateChances()
	end
	
	--������� ������ �� ������� �� ������. ��, �� ������ � �������.
	--����� ������ ��� �������� �� ��������, � ������� ���� ����� � ������ ������.
	function sleepingbag:RemoveSleeper(num, nostatechange)
		--print("----RemoveSleeper "..tostring(self.inst)..", num="..tostring(num)..", nostate="..tostring(nostatechange))
		if type(num) ~= "number" then
			print("TENT ERROR: Argument for RemoveSleeper must be a number. "..tostring(num))
			return
		end
		local sleeper = self.players[num]
		if sleeper ~= nil then
			self:UpdateChances() --���������� ����������� ������
			table.remove(self.players,num)
			sleeper.sleepingbag = nil
			sleeper._sleepingbag_ = nil --��������� �� �����, ����� �� ��������� �����.
			if self.onwake ~= nil then
				self.onwake(self.inst, sleeper, nostatechange) --�������� ���������� sleeper
			end
			self:UpdateChances() --��������� ����������.
			local tm = sleeper.pants_chance_sum or 0 --�������� ���� (����� ����������� ��� � ��������)
		else
			print("TENT ERROR: No sleeper in array with number "..num)
			print("Num sleepers = "..#self.players)
			for i=1,#self.players do
				print('Sleeper #'..i..": "..tostring(self.players[i]))
			end
		end
	end

	--������� ���� ������
	function sleepingbag:DoWakeUpAll()
		--print("--DoWakeUpAll "..tostring(self.inst))
		--������� ���� �������
		for i=#self.players,1,-1 do
			self:RemoveSleeper(i) --,false) --���� �������� ����� ���������
		end
	end
	
	--������� ������ ������, ����� �������� ���� ������ �� ����
	function sleepingbag:RemoveSleeperByInst(player, nostatechange)
		--print("--RemoveSleeperByInst "..tostring(self.inst)..", player="..tostring(player)..", nostate="..tostring(nostatechange))
		local sleeper, num = self:CheckSleeper(player)
		if not sleeper then
			print("TENT ERROR: Can't find sleeper in RemoveSleeperByInst "..tostring(player))
			return
		end
		self:RemoveSleeper(num, nostatechange)
	end
	
	function sleepingbag:CountPlayers()
		--print("CountPlayers - "..#self.players)
		return #self.players
	end
	
end

local function add_newhook_OnWakeUp(inst)
	--print("add_newhook_OnWakeUp "..tostring(inst))
	local old_OnWakeUp = inst.OnWakeUp
	inst.OnWakeUp = function(inst)
		--����� ����� �������� ����� ����� ����������. nostatechange === true (� ����� ������)
		--� ��� ��� ��� ������ �� �������! ��������! 
		--�� � ��� ���� ��������� �����, ������� ���������� _sleepingbag_
		if inst._sleepingbag_ then
			print("_sleepingbag_ = "..tostring(inst._sleepingbag_.inst))
			inst._sleepingbag_.components.sleepingbag:RemoveSleeperByInst(inst,true) --��������� ����� ���������.
		end
		return old_OnWakeUp(inst)
	end
end

--������������ ������� (�������) �������������� ������ ��� �������.
local function new_DoSleep(self,doer)
	--print("new_DoSleep "..tostring(self.inst))
    if doer.sleepingbag == nil then
		self:AddSleeper(doer)
        doer.sleepingbag = self.inst --NB
		doer._sleepingbag_ = self.inst --��� ������� �����������.
        if self.onsleep ~= nil then
            self.onsleep(self.inst, doer)
        end
    end
end

--��������� ���� ����������. ���� ���� ����� - ������ �����.
local function PostWakeUp_fn(inst) --inst==tent
	--print("PostWakeUp_fn "..tostring(inst))
	inst.post_wakeup_task = nil --��������, ��� ������� ����������.
	local sb = inst.components.sleepingbag --������ �� ���������.
	--���������� � ���������� ����� ��������. ���� ������ �� ������������� � ������� ��� ��������� ������.
	--��������� ���� �������, ������� ������������� ��� ��� ���� � �������.
	local assoc_sleeping = {}
	for i,v in ipairs(AllPlayers) do
		if v.sleepingbag == inst then
			assoc_sleeping[v] = true
		end
	end
	--�������� ���� ������������������ � �������. � ������� ����, ��� �� ���� ����� (�.�. ��� ������ ��� ���������).
	for i=#sb.players,1,-1 do
		if not assoc_sleeping[sb.players[i] ] then --����� ��� ����� �� ����� ������.
			sb:RemoveSleeper(i) --, nostatechange) --����������� ������ ���������. ����� ������ ���� ��� ���������� �����.
		end
	end
end


--��� �������� � ���, ��� ���� nostatechange==true, �� �� DoWakeUp ����������� ������� OnWakeUp,
--������� ����� �������� ���������� �� OnWakeUp � ����������� ������ �� �������, ������� �����������
--��� ����� ���������. ��������� � ������������ ������� ������ ���������.

--����� ������� ����������. b - ��������� ��������, �����������, ��� ���������� ������� ���.
local function new_DoWakeUp(self,nostatechange,b) --����� b - ������ �� ������, �� ������ ������ 0
	--print("new_DoWakeUp "..tostring(self.inst)..", b="..tostring(b))
	if b == ALL_PEOPLE then --��� ������ ������, ����� �����, ����� ���� ���������� ���.
		self:DoWakeUpAll()
		return
	end
	--���� �����-�� ����� (���� ��� �� ��������) ������� ����� ������ �� ������ �� ����� ������ ���.
	if b and type(b) == "table" then
		self:RemoveSleeperByInst(b,nostatechange) -----> ������������ ���.
		print("TENT ERROR: Got unreachable code!")
	end
	--� ������ ����� ������ �����. ������� ���������� �� �������� ����. �����?
	--� ����� ��� �����, ��� � ����� �����������. �� ���� ��������, � ����� ������ ���� ���������.
	if not self.inst.post_wakeup_task then
		self.inst.post_wakeup_task = self.inst:DoTaskInTime(0,PostWakeUp_fn)
	end
	--[[
	�������� onwake ���� � �������, ���� � ���� �� OnWakeUp.
    if sleeper ~= nil and sleeper.sleepingbag == self.inst then
        sleeper.sleepingbag = nil
        self.sleeper = nil
        if self.onwake ~= nil then
            self.onwake(self.inst, sleeper, nostatechange)
        end
    end
	--]]
end

--��� ����� ������� ������� ������������ (�������� ��������).
--����� �� �������, ��� ������ ���������.
local function onwake(inst, sleeper, nostatechange)
	--print("onwake "..tostring(inst)..", sleeper = "..tostring(sleeper)..", nostate="..tostring(nostatechange))
    --inst:StopWatchingWorldState("phase", wakeuptest) --������� �� ���������� ����������. ������ ������ ���. �������� �� ������� ������.
    --sleeper:RemoveEventCallback("onignite", onignite, inst)
	
	--���, ��, ��� ��-������ �������� �������, �.�. ������ ���������.
    if not nostatechange then
        if sleeper.sg:HasStateTag("tent") then
            sleeper.sg.statemem.iswaking = true
        end
        sleeper.sg:GoToState("wakeup")
    end

	local cnt = inst.components.sleepingbag:CountPlayers() --���������� ������.
	
	--������ ������� �� ���� ������ ���� ��������� ��������� ������ (����� � ������� ����� ������� �����)
	if inst.components.finiteuses.current > 1 or cnt == 0 then
		inst.components.finiteuses:Use()
		--���� ���� ���-�� ������� � ������� �� ����� �����������, ���������� �������� �� �����.
		--��� ���� ��� ������ ������� onwake � ��� ������ ��������.
	end
	
	--�����, ��������� ������� �� ���������� ������.
	if cnt == 0 then --��� ����������
		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
			inst.sleeptask = nil
		end

		if inst.sleep_anim ~= nil then
			inst.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onsleeptick(inst) --, sleeper) --������� �������� � ����������.
	local players = inst.components.sleepingbag.players
	local cnt = #players --������� ���������� ������.
	--�� ���� ������ �� �� �� �����, ������ ��� ������� �������.
	--� ��� ����� ���� ���������� �� � �������:
	for i=cnt,1,-1 do --i,sleeper in ipairs(players) do
		local sleeper = players[i]
		if not (sleeper.components.health and sleeper.replica and sleeper.replica.health) then
			table.remove(players,i)
			print("WARNING TOGETHER FOREVER: Avoiding crash for player "..tostring(sleeper.name))
		else
		--����� ��� ���������...
	
    local isstarving = sleeper.components.beaverness ~= nil and sleeper.components.beaverness:IsStarving()

    if sleeper.components.hunger ~= nil then
        sleeper.components.hunger:DoDelta(inst.hunger_tick, true, true)
        isstarving = sleeper.components.hunger:IsStarving()
    end

    if sleeper.components.sanity ~= nil and sleeper.components.sanity:GetPercentWithPenalty() < 1 then
        sleeper.components.sanity:DoDelta(TUNING.SLEEP_SANITY_PER_TICK * cnt, true) ----> ����������� ����� �� ����������.
    end

    if not isstarving and sleeper.components.health ~= nil then
        sleeper.components.health:DoDelta(TUNING.SLEEP_HEALTH_PER_TICK * 2, true, inst.prefab, true)
    end

    if sleeper.components.temperature ~= nil then
        if inst.is_cooling then
            if sleeper.components.temperature:GetCurrent() > TUNING.SLEEP_TARGET_TEMP_TENT then
                sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() - TUNING.SLEEP_TEMP_PER_TICK)
            end
        elseif sleeper.components.temperature:GetCurrent() < TUNING.SLEEP_TARGET_TEMP_TENT then
            sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
        end
    end

    if isstarving then
        inst.components.sleepingbag:DoWakeUp(nil,sleeper) --��, ���� ��� �� ���, �� �����������. �� ������ ������ ���������� ����.
    end
	
	
		end
	end --for sb.players
end

local function onsleep(inst, sleeper)
	--print("onsleep "..tostring(inst)..", sleeper="..tostring(sleeper))
    --inst:WatchWorldState("phase", wakeuptest)
    --sleeper:ListenForEvent("onignite", onignite, inst)

	--��-��, ����� ������.
	--�����, ����� ����� ��������� � ���������� ������ � ��� ������, ���� ���-�� ����� � ��� ������ �������.
	local cnt = inst.components.sleepingbag:CountPlayers() --���������� ������.
	if cnt == 1 then
		if inst.sleep_anim ~= nil then
			inst.AnimState:PlayAnimation(inst.sleep_anim, true)
		end

		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
		end
		inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, onsleeptick) --, nil, sleeper)
		--�, ���, ���, ������� �� �� �������� � onsleeptick. �������� �������� ��� onsleeptick, ����� ��������� ���� ������.
	end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function Sex(inst)
	local sb = inst.components.sleepingbag
	if sb and sb.players ~= nil and #sb.players > 1 then
	    for i=1,#sb.players do
		    if sb.players[i] ~= nil then
			    local decay = 0.3+i/10
				sb.players[i]:DoTaskInTime(decay, 
				function()
			        if math.random() < 0.4 then
						DoHurtSound(sb.players[i])
				        sb.players[i].SoundEmitter:PlaySound("dontstarve/creatures/spat/spit_playerunstuck")
			        else
				        sb.players[i].SoundEmitter:PlaySound("dontstarve/creatures/spat/spit_playerunstuck")
			        end	
                end)				 
		    end
	    end
	end
end

local function common_fn(bank, build, icon, tag)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst:AddTag("tent")
    inst:AddTag("structure")
    if tag ~= nil then
        inst:AddTag(tag)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon(icon)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered) --�������� ���� ��� �� ������ onhit
    inst.components.workable:SetOnWorkCallback(onhit) --�������� (nil,0)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished) --������� ������ ���� ������� ��������� �����.

    inst:AddComponent("sleepingbag")
	local sb = inst.components.sleepingbag
	sb.players = {} --��� ������ ������� � ������� ���������� - ���� ������ �������.
    sb.onsleep = onsleep
    sb.onwake = onwake
    --convert wetness delta to drying rate
    sb.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
	--�������������� ����������� ������ � ���������� ����������.
	sb.DoSleep = new_DoSleep --no backup
	sb.DoWakeUp = new_DoWakeUp --no backup
	sb.OnRemoveFromEntity = sb.DoWakeUpAll --no backup

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt) --�� ���������

    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
	inst:ListenForEvent("onignite", onignite) --��������� ������
	
	inst:WatchWorldState("phase", wakeuptest) --��������� ������


    inst.OnSave = onsave 
    inst.OnLoad = onload
	
	--inst:DoPeriodicTask(1.5, Sex)

    MakeHauntableWork(inst)
	
	--inst:DoTaskInTime(2,inst.Remove) --��� ���? ������������ �� ��������?

    return inst
end

local function tent()
    local inst = common_fn("tent", "tent", "tent.png")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sleep_phase = "night"
    inst.sleep_anim = "sleep_loop"
    inst.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
    --inst.is_cooling = false

    inst.components.finiteuses:SetMaxUses(TUNING.TENT_USES)
    inst.components.finiteuses:SetUses(TUNING.TENT_USES)

    return inst
end

local function siestahut()
    local inst = common_fn("siesta_canopy", "siesta_canopy", "siestahut.png", "siestahut")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sleep_phase = "day"
    --inst.sleep_anim = nil
    inst.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK / 3
    inst.is_cooling = true

    inst.components.finiteuses:SetMaxUses(TUNING.SIESTA_CANOPY_USES)
    inst.components.finiteuses:SetUses(TUNING.SIESTA_CANOPY_USES)

    return inst
end

return Prefab("tent", tent, tent_assets),
    MakePlacer("tent_placer", "tent", "tent", "idle"),
    Prefab("siestahut", siestahut, siestahut_assets),
    MakePlacer("siestahut_placer", "siesta_canopy", "siesta_canopy", "idle")
