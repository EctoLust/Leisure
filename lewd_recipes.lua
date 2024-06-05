local RECIPETABS = GLOBAL.RECIPETABS

GLOBAL.STRINGS.NAMES.SEX_TAB = "SEX_TAB"
GLOBAL.STRINGS.TABS.SEX_TAB = "Sex"
GLOBAL.RECIPETABS['SEX_TAB'] = {str = "SEX_TAB", sort=7, icon = "sex_tab.tex", icon_atlas = "images/sex_tab.xml"}

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

STRINGS.UI.CRAFTING_FILTERS.SEX_TAB = "Sex"

AddRecipeFilter({name="SEX_TAB",atlas = "images/sex_tab.xml", image = "sex_tab.tex"})

local sexrecipes={
"lube",
"stickysalve",
"dildo",
"strapon",
"vibrator",
"buttplug",
"buttplug_red",
"buttplug_blue",
"plug_foxtail",
"shadowgoop",
"sciencewife",
"towel",
"anticumpen",
"boobspen",
"clearpen",
"libidopill",
"antilibidopill",
"plantjuice",
}

for k,v in pairs(sexrecipes) do
    AddRecipeToFilter(v,"SEX_TAB")
end

AddRecipeToFilter("Sex","SEX_TAB")


local function QuickAddRecipe(prefab, ings, tech, placable, owner)
    local placercfg = prefab.."_placer"
	if placable == nil then
	     placercfg = nil
	end
	
	local config = 
	{
        image = prefab..".tex", 
        atlas = "images/inventoryimages/"..prefab..".xml",
		placer = placercfg,
		builder_tag = owner
	}
	
	AddRecipe2(prefab,ings,tech,config)
end

QuickAddRecipe("lube", 
{
    GLOBAL.Ingredient("glommerfuel", 1),
	GLOBAL.Ingredient("healingsalve", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("stickysalve", 
{
    GLOBAL.Ingredient("honey", 2)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("dildo", 
{
    GLOBAL.Ingredient("nitre", 2)
},GLOBAL.TECH.NONE)

QuickAddRecipe("strapon", 
{
    GLOBAL.Ingredient("nitre", 2)
},GLOBAL.TECH.NONE)

QuickAddRecipe("vibrator", 
{
    GLOBAL.Ingredient("transistor", 2),
	GLOBAL.Ingredient("gears", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("buttplug", 
{
    GLOBAL.Ingredient("flint", 5),
	GLOBAL.Ingredient("purplegem", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("buttplug_red", 
{
    GLOBAL.Ingredient("flint", 5),
	GLOBAL.Ingredient("redgem", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("buttplug_blue", 
{
    GLOBAL.Ingredient("flint", 5),
	GLOBAL.Ingredient("bluegem", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("plug_foxtail", 
{
    GLOBAL.Ingredient("rope", 1),
	GLOBAL.Ingredient("beefalowool", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("chaintits", 
{
    GLOBAL.Ingredient("flint", 10)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("shadowgoop", 
{
    GLOBAL.Ingredient("nightmarefuel", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("sciencewife", 
{
    GLOBAL.Ingredient("log", 4),
	GLOBAL.Ingredient("beefalowool", 3)
},GLOBAL.TECH.NONE, true)

QuickAddRecipe("towel", 
{
    GLOBAL.Ingredient("silk", 1)
},GLOBAL.TECH.NONE)

QuickAddRecipe("anticumpen", 
{
    GLOBAL.Ingredient("blue_cap", 1),
	GLOBAL.Ingredient("stinger", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("boobspen", 
{
    GLOBAL.Ingredient("red_cap", 1),
	GLOBAL.Ingredient("stinger", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("clearpen", 
{
    GLOBAL.Ingredient("petals", 2),
	GLOBAL.Ingredient("stinger", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("libidopill", 
{
    GLOBAL.Ingredient("red_cap", 1),
	GLOBAL.Ingredient("blue_cap", 1),
	GLOBAL.Ingredient("green_cap", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("antilibidopill", 
{
    GLOBAL.Ingredient("green_cap", 3)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("plantjuice", 
{
    GLOBAL.Ingredient("plantmeat", 1)
},GLOBAL.TECH.SCIENCE_ONE)

QuickAddRecipe("wormla_whip", 
{
    GLOBAL.Ingredient("cutreeds", 3),
	GLOBAL.Ingredient("stinger", 3)
},GLOBAL.TECH.SCIENCE_ONE, nil, "wormla")

AddIngredientValues({"petals"}, {petals = 1})
AddIngredientValues({"spidergland"}, {spidergland = 1})

local glommerfuel =
{
    name = "glommerfuel",
	test = function(cooker, names, tags) return names.petals and names.spidergland and tags.petals >= 2 and tags.spidergland >= 1 end,
	priority = 1,
	weight = 1,
	foodtype="GENERIC",
	cooktime = 1,
}

AddCookerRecipe("cookpot",glommerfuel)