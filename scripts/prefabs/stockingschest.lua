require "prefabutil"

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end 

local function AddStockings(inst)
	inst.components.container.slots = {}
	inst.components.container:GiveItem(SpawnPrefab("stockings_red"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_pink"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_purple"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_black"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_playful"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_shortblack"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_shortblue"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_shortpink"))
	inst.components.container:GiveItem(SpawnPrefab("stockings_pants"))
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
	for x = 1, #inst.components.container.slots, 1 do 
	    local item = inst.components.container:GetItemInSlot(x)
		if item then
		    if not item:HasTag("stockings") then
		        inst.components.container:DropItem(item)
		    end
		end
	end
	AddStockings(inst)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
	AddStockings(inst)
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function MakeChest(name, bank, build, indestructible, custom_postinit, prefabs, override_widget)
    local assets =
    {
        Asset("ANIM", "anim/"..build..".zip"),
        Asset("ANIM", "anim/ui_chest_3x2.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("structure")
        inst:AddTag("chest")
		inst:AddTag("stockingschest")

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("closed")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()
		local size = 0.78
		inst.Transform:SetScale(size,size,size)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(override_widget or "treasurechest")
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose

        if not indestructible then
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)

            MakeSmallBurnable(inst, nil, nil, true)
            MakeMediumPropagator(inst)
        end

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
		inst:AddComponent("named")
	    inst.components.named:SetName("Tiny chest")
	    inst.components.inspectable:SetDescription("Overfiled with sexy stockings!")

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

        inst.OnSave = onsave 
        inst.OnLoad = onload

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeChest("stockingschest", "chest", "treasure_chest", false, nil, { "collapse_small" })