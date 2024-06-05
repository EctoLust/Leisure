
GLOBAL.POSES_BY_PREFAB = {}
GLOBAL.POSES_BY_GROUP = {}
GLOBAL.LEWD_CATALOG = {}
GLOBAL.LEWD_CATALOG_ANIMS = {}

local function AddPosesGroup(group, array)
    if array then
	    GLOBAL.POSES_BY_GROUP[group] = {}
		GLOBAL.POSES_BY_GROUP[group] = array
	end
end

local function LinkPosesGroup(prefab, group)
    -- Use prefab name as group name if isn't set.
    if group then
        GLOBAL.POSES_BY_PREFAB[prefab] = group
	else
	    GLOBAL.POSES_BY_PREFAB[prefab] = prefab
	end
end

GLOBAL.GetPosesGroup = function(prefab)  
    -- Not need any calculating.
	if prefab == "" then
	    return ""
	end
	
	local players = GLOBAL.GetActiveCharacterList()
	for x = 1, #players, 1 do
	 -- Players have not fixed prefab, they always by name of character
	 -- So if is any of avalible character return that is player.
	    if prefab == players[x] then
		    return "player"
		end
	end
	-- Checking array if we have linked poses group
	if GLOBAL.POSES_BY_PREFAB[prefab] ~= nil then
	    return GLOBAL.POSES_BY_PREFAB[prefab]
	else
	    return ""
	end
end

GLOBAL.AddToLewdCatalog = function(anim, group, build)
    if GLOBAL.LEWD_CATALOG_ANIMS[anim] == nil then
	    GLOBAL.LEWD_CATALOG_ANIMS[anim] = true
        local data = {}
	    data["anim"] = anim
	    data["group"] = group
		data["build"] = build
	    table.insert(GLOBAL.LEWD_CATALOG, data)
	end
end

AddPosesGroup("merm", {"player_fuck_merm","player_fuck_merm2","player_fuck_merm_extra1","merm_fuck_player_bj"})
AddPosesGroup("bunnyman", {"player_fuck_bunny","player_fuck_bunny2"})
AddPosesGroup("spider", {"player_fuck_spider","player_fuck_spider2"})
AddPosesGroup("spiderqueen", {"player_fuck_spiderslut","player_fuck_spiderslut2"})
AddPosesGroup("catcoon", {"player_fuck_catcoon","player_fuck_catcoon2"})
AddPosesGroup("tentacle", {"tentacle_fuck_player_wurt","tentacle_fuck_player_wurt2"})
AddPosesGroup("hermitcrab", {"oral","ride","flipfuck","onkness","doggy","swap"})

LinkPosesGroup("merm")
LinkPosesGroup("pigman", "merm")
LinkPosesGroup("moonpig", "merm")
LinkPosesGroup("pigguard", "merm")
LinkPosesGroup("bunnyman")

LinkPosesGroup("spider")
LinkPosesGroup("spider_warrior", "spider")
LinkPosesGroup("spider_dropper", "spider")
LinkPosesGroup("spiderqueen")
LinkPosesGroup("catcoon")
LinkPosesGroup("tentacle")
LinkPosesGroup("hermitcrab")

local AddToLewdCatalog = GLOBAL.AddToLewdCatalog
	
AddToLewdCatalog("player_fuck_spider", "Spiders", "spider_build")
AddToLewdCatalog("spider_fuck_player", "Spiders", "spider_build")
AddToLewdCatalog("player_fuck_merm", "Pigmans & Merms", "pig_build")
AddToLewdCatalog("merm_fuck_player", "Pigmans & Merms", "pig_build")
AddToLewdCatalog("player_fuck_merm_extra1", "Pigmans & Merms", "pig_build")
AddToLewdCatalog("merm_fuck_player_bj", "Pigmans & Merms", "pig_build")
AddToLewdCatalog("player_fuck_bunny", "Bunnyman", "manrabbit_build")
AddToLewdCatalog("bunny_fuck_player", "Bunnyman", "manrabbit_build")
AddToLewdCatalog("slurper_fuck_player", "Slurper", "slurper_basic")
AddToLewdCatalog("player_fuck_glommer", "Glommer", "glommer")
AddToLewdCatalog("tentacle_fuck_player", "Tentacles", "tentacle")
AddToLewdCatalog("tentacle_fuck_player_wurt", "Tentacles", "tentacle")
AddToLewdCatalog("tinytentacle_fuck_player", "Tentacles", "tentacle_arm_build")
AddToLewdCatalog("darkness_fuck_player", "Shadowhands", "tentacle_arm_black_build")
AddToLewdCatalog("cookie_fuck_player", "Cookiecutter", "cookiecutter_build_rename")
AddToLewdCatalog("nightmare1_fuck_player", "Horrors", "nightmare1_alpha")
AddToLewdCatalog("hound_fuck_player", "Hounds", "hound")
AddToLewdCatalog("spiderslut_fuck_player", "Spider Queen", "spiderslut")
AddToLewdCatalog("spiderslut_fuck_player_fem", "Spider Queen", "spiderslut")
AddToLewdCatalog("player_fuck_spiderslut", "Spider Queen", "spiderslut")
AddToLewdCatalog("lureplant_fuck_player", "Lureplant", "eyeplant_trap")
AddToLewdCatalog("catcoon_fuck_player", "Catcoon", "catcoon_build")
AddToLewdCatalog("player_fuck_catcoon", "Catcoon", "catcoon_build")

-- Dildos
AddToLewdCatalog("dilding_dildo_dick", "Dildos", "dildo_dick")
AddToLewdCatalog("dilding_dildo_dick_green", "Dildos", "dildo_dick_green")
AddToLewdCatalog("dilding_dildo_dick_red", "Dildos", "dildo_dick_red")
AddToLewdCatalog("dilding_dildo_dick_yellow", "Dildos", "dildo_dick_yellow")
AddToLewdCatalog("dilding_dildo_dick_gold", "Dildos", "dildo_dick_gold")
AddToLewdCatalog("dilding_dildo_dick_rainbow", "Dildos", "dildo_dick_rainbow")
AddToLewdCatalog("vibrating", "Dildos", "vibrator_dick")
