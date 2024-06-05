--see mindcontrolover.lua for constants
local MAX_LEVEL = 135
local CONTROL_LEVEL = 110
local EXTEND_TICKS = MAX_LEVEL - CONTROL_LEVEL

local function OnAttached(inst, target)--, followsymbol, followoffset)
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
end

local function ExtendDebuff(inst)
    inst.countdown = 1000000 + (inst._level < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function OnUpdate(inst, ismastersim)
    local parent = inst.entity:GetParent()
    if parent ~= nil then
        local old = inst._level
        parent:PushEvent("mindcontrollevel", inst._level / MAX_LEVEL)

        if ismastersim and inst._level >= CONTROL_LEVEL then
            if old < CONTROL_LEVEL then
                ExtendDebuff(inst)
            end
            parent:PushEvent("mindcontrolled", { duration = TUNING.STALKER_MINDCONTROL_DURATION })
        end
    end

    if ismastersim then
        if inst.countdown > 1 then
            inst.countdown = inst.countdown - 1
        else
            inst.components.debuff:Stop()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst._level = 111

    inst:DoPeriodicTask(0, OnUpdate, nil, TheWorld.ismastersim)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(ExtendDebuff)

    ExtendDebuff(inst)

    return inst
end

return Prefab("lewd_mindcontroller", fn)
--ThePlayer.components.debuffable:AddDebuff("lewd_mindcontroller", "lewd_mindcontroller")