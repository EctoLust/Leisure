name = " A Leisure mod"
version = "0.30 OPENSOURCE EDITION"
description = "Mod to get some rest.\nVersion "..version
author = "Ecto"

forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"Ecto","lust", "lewd"}

configuration_options =
{
	{
		name = "tutorial_skip",
		label = "Skip tutorial",
		options =
		{		
			{description = "No", data = 0},
			{description = "Yes", data = 1},
			
		},
		default = 0,
	},	
	{
		name = "shadow_spawn",
		label = "Spawn shadow hands",
		options =
		{		
			{description = "Yes", data = 1},
			{description = "No", data = 0},
			
		},
		default = 1,
	},
	{
		name = "monsters_rape",
		label = "Monsters attack with sex",
		options =
		{		
			{description = "Yes", data = 1},
			{description = "No", data = 0},
			
		},
		default = 1,
	},
	{
		name = "rape_no_damage",
		label = "Rapes deals damage",
		options =
		{		
			{description = "Yes", data = 0},
			{description = "No", data = 1},
			
		},
		default = 0,
	},	
	{
		name = "lustbook",
		label = "Lust book on spawn",
		options =
		{		
			{description = "Yes", data = 1},
			{description = "No", data = 0},
			
		},
		default = 1,
	},	
	{
		name = "dildo_rain",
		label = "Dildo rain",
		options =
		{		
			{description = "Yes", data = 1},
			{description = "No", data = 0},
			
		},
		default = 1,
	},	
}