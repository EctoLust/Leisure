local assets =
{
    Asset("ANIM", "anim/whip_kinki.zip"),
    Asset("ANIM", "anim/swap_whip_kinki.zip"),
	Asset("IMAGE", "images/inventoryimages/whip_kinki.tex"),
	Asset("ATLAS", "images/inventoryimages/whip_kinki.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_whip_kinki", "swap_whip")
    owner.AnimState:OverrideSymbol("whipline", "swap_whip_kinki", "whipline")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
    if target and target:HasTag("player") then
		SayRandomSexQuote(target,STRINGS.SEX_MOANS)
		target.components.excited.libido = target.components.excited.libido+1
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whip_kinki")
    inst.AnimState:SetBuild("whip_kinki")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("whip")
	inst:AddTag("nohurt")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0.01)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.replica.inventoryitem:SetImage("whip_kinki")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/whip_kinki.xml"	

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(30)
    inst.components.finiteuses:SetUses(30)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("whip_kinki", fn, assets)
