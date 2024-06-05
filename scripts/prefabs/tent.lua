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
        inst.components.sleepingbag:DoWakeUp(nil,ALL_PEOPLE) --Проснулись все, я сказал!
    end
end

local function onfinishedsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl")
end

local function onfinished(inst)
	local cnt = inst.components.sleepingbag:CountPlayers() --NB: Лишняя проверка. Если забагуется, то палатка будет вечной.
    if not inst:HasTag("burnt") and cnt == 0 then
        inst.AnimState:PlayAnimation("destroy")
        inst:ListenForEvent("animover", inst.Remove)
        inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
        inst.persists = false --да, не сохраняем
        inst:DoTaskInTime(16 * FRAMES, onfinishedsound)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end

local function onignite(inst)
	--Проверка на sleeper осуществляется в самом компоненте. 
	--А вообще у нас их может быть несколько, так что нельзя делить на черное и белое.
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
        inst.components.sleepingbag:DoWakeUp(nil,ALL_PEOPLE) --А ну-ка быстро все проснулись! Типа рассвет.
    end
end


--Init sleepingbag (tuning)
do
	local sleepingbag = require "components/sleepingbag"
	--sleepingbag.players = {} --Ээээ... Нельзя так делать, приятель! Это главный источник багов.
	
	--Обновляет таймеры всех игроков (для подсчета шанса получения трусов)
	function sleepingbag:UpdateChances()
		local time_now = _G.GetTime()
		local cnt = #self.players
		for i=1,cnt do
			local sleeper = self.players[i]
			if not sleeper.pants_chance_sum then
				sleeper.pants_chance_sum = 0 --на всякий пожарный, хотя эта цифра должна быть.
			end
			if (cnt > 1) and (not sleeper.pants_chance_start_tm) then --Время не считается, а надо (ведь групповуха)
				sleeper.pants_chance_start_tm = time_now
			elseif (cnt <= 1) and (sleeper.pants_chance_start_tm) then --Время считает, но пора его остановить
				--Добавляем к сумме, кто сколько спал.
				sleeper.pants_chance_sum = sleeper.pants_chance_sum + (time_now - sleeper.pants_chance_start_tm)
				sleeper.pants_chance_start_tm = nil --Прекращаем считать
			elseif sleeper.pants_chance_start_tm then --Если считаем, то просто перекачиваем время в надежное место
				--Хотя это не обязательно, строго говоря.
				sleeper.pants_chance_sum = sleeper.pants_chance_sum + (time_now - sleeper.pants_chance_start_tm)
				sleeper.pants_chance_start_tm = time_now
			end
		end
	end
	
	--Проверяет наличие определенного игрока в палатке (перебором).
	function sleepingbag:CheckSleeper(sleeper)
		--print("--CheckSleeper "..tostring(self.inst)..", sleeper="..tostring(sleeper))
		for i=1,#self.players do
			if self.players[i] == sleeper then
				return sleeper, i
			end
		end
	end

	--Добавляет еще одного игрока в палатку
	function sleepingbag:AddSleeper(sleeper)
		--print("----AddSleeper "..tostring(self.inst)..", sleeper="..tostring(sleeper))
		if self:CheckSleeper(sleeper) then --debug
			print("TENT ERROR: player already in tent!!! - "..tostring(sleeper))
			return
		end
		--В момент добавления важно прочекать всех остальных на предмет валидности, а то мало ли.
		for i=#self.players,1,-1 do
			if not self.players[i]:IsValid() then
				table.remove(self.players,i) --Просто вычеркиваем, потому что ничего делать уже не надо.
			end
		end
		--Само добавление
		table.insert(self.players,sleeper)
		sleeper.pants_chance_sum = 0 --Обнуляем шансы при попадании в палатку.
		--Далее необходимо пересчитать все шансы и таймеры всех обитателей палатки
		self:UpdateChances()
	end
	
	--Удаляет игрока из палатки ПО НОМЕРУ. Да, по номеру в массиве.
	--Здесь просто все действия по удалению, а разного рода поиск в других местах.
	function sleepingbag:RemoveSleeper(num, nostatechange)
		--print("----RemoveSleeper "..tostring(self.inst)..", num="..tostring(num)..", nostate="..tostring(nostatechange))
		if type(num) ~= "number" then
			print("TENT ERROR: Argument for RemoveSleeper must be a number. "..tostring(num))
			return
		end
		local sleeper = self.players[num]
		if sleeper ~= nil then
			self:UpdateChances() --Записываем накопленные данные
			table.remove(self.players,num)
			sleeper.sleepingbag = nil
			sleeper._sleepingbag_ = nil --Подчищаем за собой, чтобы не оставлять мусор.
			if self.onwake ~= nil then
				self.onwake(self.inst, sleeper, nostatechange) --Передаем правильный sleeper
			end
			self:UpdateChances() --Обновляем оставшихся.
			local tm = sleeper.pants_chance_sum or 0 --Получаем шанс (время совместного сна в секундах)
		else
			print("TENT ERROR: No sleeper in array with number "..num)
			print("Num sleepers = "..#self.players)
			for i=1,#self.players do
				print('Sleeper #'..i..": "..tostring(self.players[i]))
			end
		end
	end

	--Удаляет всех спящих
	function sleepingbag:DoWakeUpAll()
		--print("--DoWakeUpAll "..tostring(self.inst))
		--Удаляем всех игроков
		for i=#self.players,1,-1 do
			self:RemoveSleeper(i) --,false) --всем засылаем смену состояния
		end
	end
	
	--Удаляет одного игрока, когда известна лишь ссылка на него
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
		--Здесь имеем перехват сразу после просыпания. nostatechange === true (я почти уверен)
		--У нас уже нет ссылки на палатку! Проблема! 
		--Но у нас есть резервная копия, которая называется _sleepingbag_
		if inst._sleepingbag_ then
			print("_sleepingbag_ = "..tostring(inst._sleepingbag_.inst))
			inst._sleepingbag_.components.sleepingbag:RemoveSleeperByInst(inst,true) --Запрещаем смену состояния.
		end
		return old_OnWakeUp(inst)
	end
end

--Существующие функции (парочку) переопределяем только для палатки.
local function new_DoSleep(self,doer)
	--print("new_DoSleep "..tostring(self.inst))
    if doer.sleepingbag == nil then
		self:AddSleeper(doer)
        doer.sleepingbag = self.inst --NB
		doer._sleepingbag_ = self.inst --Для личного пользования.
        if self.onsleep ~= nil then
            self.onsleep(self.inst, doer)
        end
    end
end

--Проверяет всех пассажиров. Если есть зайцы - кикает нафиг.
local function PostWakeUp_fn(inst) --inst==tent
	--print("PostWakeUp_fn "..tostring(inst))
	inst.post_wakeup_task = nil --Помечаем, что функция отработала.
	local sb = inst.components.sleepingbag --Ссылка на компонент.
	--Информация в компоненте могла устареть. Наша задача ее актуализовать и сделать всю остальную работу.
	--Проверяем всех игроков, которые действительно все еще спят в палатке.
	local assoc_sleeping = {}
	for i,v in ipairs(AllPlayers) do
		if v.sleepingbag == inst then
			assoc_sleeping[v] = true
		end
	end
	--Провряем всех зарегистрированных в палатке. И удаляем всех, кто не спит здесь (т.е. кто только что проснулся).
	for i=#sb.players,1,-1 do
		if not assoc_sleeping[sb.players[i] ] then --Игрок уже точно не среди спящих.
			sb:RemoveSleeper(i) --, nostatechange) --Обязательно меняем состояние. Тихие должны были уже выписаться ранее.
		end
	end
end


--Вся прелесть в том, что если nostatechange==true, то за DoWakeUp обязательно следует OnWakeUp,
--поэтому можно спокойно повеситься на OnWakeUp и отслеживать ссылки на игроков, которые просыпаются
--без смены состояния. Остальным в обязательном порядке менять состояние.

--Новая функция просыпания. b - возможный параметр, указывающий, что проснуться обязаны все.
local function new_DoWakeUp(self,nostatechange,b) --Здесь b - ссылка на игрока, но обычно просто 0
	--print("new_DoWakeUp "..tostring(self.inst)..", b="..tostring(b))
	if b == ALL_PEOPLE then --Тот редкий случай, когда нужно, чтобы тупо проснулись все.
		self:DoWakeUpAll()
		return
	end
	--Если каким-то чудом (хотя это не возможно) получим здесь ссылку на игрока то будим только его.
	if b and type(b) == "table" then
		self:RemoveSleeperByInst(b,nostatechange) -----> недостижимый код.
		print("TENT ERROR: Got unreachable code!")
	end
	--А теперь самое тонкое место. Функция вызывается из глубоких мест. Верно?
	--В целом нам пофиг, кто и когда просыпается. Мы чуть подождем, а потом просто всех прочекаем.
	if not self.inst.post_wakeup_task then
		self.inst.post_wakeup_task = self.inst:DoTaskInTime(0,PostWakeUp_fn)
	end
	--[[
	Посылаем onwake либо в таймере, либо в хуке на OnWakeUp.
    if sleeper ~= nil and sleeper.sleepingbag == self.inst then
        sleeper.sleepingbag = nil
        self.sleeper = nil
        if self.onwake ~= nil then
            self.onwake(self.inst, sleeper, nostatechange)
        end
    end
	--]]
end

--Это самая главная функция отслеживания (возможно багована).
--Здесь мы смотрим, КТО ИМЕННО проснулся.
local function onwake(inst, sleeper, nostatechange)
	--print("onwake "..tostring(inst)..", sleeper = "..tostring(sleeper)..", nostate="..tostring(nostatechange))
    --inst:StopWatchingWorldState("phase", wakeuptest) --Никогда не прекращаем мониторить. Просто делаем доп. проверку на наличие спящих.
    --sleeper:RemoveEventCallback("onignite", onignite, inst)
	
	--Так, ну, это по-любому придется сделать, т.к. спящий проснулся.
    if not nostatechange then
        if sleeper.sg:HasStateTag("tent") then
            sleeper.sg.statemem.iswaking = true
        end
        sleeper.sg:GoToState("wakeup")
    end

	local cnt = inst.components.sleepingbag:CountPlayers() --Количество спящих.
	
	--Тратим палатку до нуля только если проснулся последний спящий (иначе в палатку можно залезть снова)
	if inst.components.finiteuses.current > 1 or cnt == 0 then
		inst.components.finiteuses:Use()
		--Даже если кто-то залезет в палатку во время уничтожения, повторного удаления не будет.
		--При этом все спящие получат onwake в сам момент удаления.
	end
	
	--Далее, поведение зависит от количества свящих.
	if cnt == 0 then --Все проснулись
		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
			inst.sleeptask = nil
		end

		if inst.sleep_anim ~= nil then
			inst.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onsleeptick(inst) --, sleeper) --никаких слиперов в параметрах.
	local players = inst.components.sleepingbag.players
	local cnt = #players --считаем количество спящих.
	--По сути делаем всё то же самое, только для КАЖДОГО спящего.
	--А для этого тупо перебираем их в массиве:
	for i=cnt,1,-1 do --i,sleeper in ipairs(players) do
		local sleeper = players[i]
		if not (sleeper.components.health and sleeper.replica and sleeper.replica.health) then
			table.remove(players,i)
			print("WARNING TOGETHER FOREVER: Avoiding crash for player "..tostring(sleeper.name))
		else
		--Далее без изменений...
	
    local isstarving = sleeper.components.beaverness ~= nil and sleeper.components.beaverness:IsStarving()

    if sleeper.components.hunger ~= nil then
        sleeper.components.hunger:DoDelta(inst.hunger_tick, true, true)
        isstarving = sleeper.components.hunger:IsStarving()
    end

    if sleeper.components.sanity ~= nil and sleeper.components.sanity:GetPercentWithPenalty() < 1 then
        sleeper.components.sanity:DoDelta(TUNING.SLEEP_SANITY_PER_TICK * cnt, true) ----> Увеличенный бонус от групповухи.
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
        inst.components.sleepingbag:DoWakeUp(nil,sleeper) --Да, если что не так, то просыпаемся. Но только данный конкретный перс.
    end
	
	
		end
	end --for sb.players
end

local function onsleep(inst, sleeper)
	--print("onsleep "..tostring(inst)..", sleeper="..tostring(sleeper))
    --inst:WatchWorldState("phase", wakeuptest)
    --sleeper:ListenForEvent("onignite", onignite, inst)

	--Да-да, новый спящий.
	--Думаю, имеет смысл суетиться с анимациями только в том случае, если кто-то залез в еще пустую палатку.
	local cnt = inst.components.sleepingbag:CountPlayers() --Количество спящих.
	if cnt == 1 then
		if inst.sleep_anim ~= nil then
			inst.AnimState:PlayAnimation(inst.sleep_anim, true)
		end

		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
		end
		inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, onsleeptick) --, nil, sleeper)
		--А, вот, нет, спящего мы не передаем в onsleeptick. Придется поменять сам onsleeptick, чтобы учитывать всех спящих.
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
    inst.components.workable:SetOnFinishCallback(onhammered) --Выгоняем всех еще на стадии onhit
    inst.components.workable:SetOnWorkCallback(onhit) --Выгоняем (nil,0)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished) --Удаляем только если палатка полностью пуста.

    inst:AddComponent("sleepingbag")
	local sb = inst.components.sleepingbag
	sb.players = {} --Для каждой палатки и каждого компонента - свой массив игроков.
    sb.onsleep = onsleep
    sb.onwake = onwake
    --convert wetness delta to drying rate
    sb.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
	--Переопределяем стандартные методы и переменные компонента.
	sb.DoSleep = new_DoSleep --no backup
	sb.DoWakeUp = new_DoWakeUp --no backup
	sb.OnRemoveFromEntity = sb.DoWakeUpAll --no backup

    MakeSnowCovered(inst)
    inst:ListenForEvent("onbuilt", onbuilt) --Не интересно

    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)
	inst:ListenForEvent("onignite", onignite) --Мониторим всегда
	
	inst:WatchWorldState("phase", wakeuptest) --Мониторим всегда


    inst.OnSave = onsave 
    inst.OnLoad = onload
	
	--inst:DoPeriodicTask(1.5, Sex)

    MakeHauntableWork(inst)
	
	--inst:DoTaskInTime(2,inst.Remove) --Что это? Тестирование на вшивость?

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
