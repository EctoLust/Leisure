local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.WORMLA_HEALTH = 150
TUNING.WORMLA_HUNGER = 150
TUNING.WORMLA_SANITY = 200

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WORMLA = {
	"petals",
	"petals",
	"petals",
	"petals",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.WORMLA
end
local prefabs = FlattenTree(start_inv, true)

local function OnIsSpring(inst, isspring)
    if isspring then
	    inst.components.excited.springfever = true
	else
	    inst.components.excited.springfever = false
	end
end

local common_postinit = function(inst) 
    inst:AddTag("plantkin")
	inst:AddTag("wormla")
    inst:AddTag("healonfertilize")
	inst.MiniMapEntity:SetIcon( "wormla.tex" )
end

local master_postinit = function(inst)
    inst.starting_inventory = {
	"petals",
	"petals",
	"petals",
	"wormla_book",
	}
	
	inst.soundsname = "willow"
	
    if LOC.GetTextScale() == 1 then
        inst.components.talker.fontsize = 40
    end
    inst.components.talker.font = TALKINGFONT_WORMWOOD

	inst.components.health:SetMaxHealth(TUNING.WORMLA_HEALTH)
	inst.components.hunger:SetMax(TUNING.WORMLA_HUNGER)
	inst.components.sanity:SetMax(TUNING.WORMLA_SANITY)
	
    inst.components.combat.damagemultiplier = 0.85
	
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	inst.components.health.fire_damage_scale = TUNING.WORMWOOD_FIRE_DAMAGE
	inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME)
	inst:WatchWorldState("isspring", OnIsSpring)
end

return MakePlayerCharacter("wormla", prefabs, assets, common_postinit, master_postinit, prefabs)
