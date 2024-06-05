local assets =
{
	Asset( "ANIM", "anim/wormla.zip" ),
	Asset( "ANIM", "anim/ghost_wormla_build.zip" ),
}

local skins =
{
	normal_skin = "wormla",
	ghost_skin = "ghost_wormla_build",
}

return CreatePrefabSkin("esctemplate_none",
{
	base_prefab = "wormla",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"WORMLA", "CHARACTER", "BASE"},
	build_name_override = "wormla",
	rarity = "Character",
})