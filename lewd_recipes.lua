local RECIPETABS = GLOBAL.RECIPETABS

-- ============================================================================
-- 1. STABLE TECH ENGINE REGISTRATION (Crucial: Keep this at the top)
-- ============================================================================
if GLOBAL.TECH and GLOBAL.TECH.NONE then
    for tech_name, tech_table in pairs(GLOBAL.TECH) do
        if type(tech_table) == "table" then
            if tech_table.LEISURE_TECH == nil then
                tech_table.LEISURE_TECH = 0
            end
        end
    end
    GLOBAL.TECH.LEISURE_TECH_ONE = GLOBAL.TECH.SCIENCE_TWO
end

local LEVEL_SHRINE = GLOBAL.TECH.LEISURE_TECH_ONE

-- ============================================================================
-- 2. CUSTOM FILTER TAB CONFIGURATION
-- ============================================================================
GLOBAL.STRINGS.NAMES.SEX_TAB = "SEX_TAB"
GLOBAL.STRINGS.TABS.SEX_TAB = "Sex"
GLOBAL.RECIPETABS['SEX_TAB'] = {str = "SEX_TAB", sort=7, icon = "sex_tab.tex", icon_atlas = "images/sex_tab.xml"}

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
STRINGS.UI.CRAFTING_FILTERS.SEX_TAB = "Sex"

AddRecipeFilter({name="SEX_TAB", atlas = "images/sex_tab.xml", image = "sex_tab.tex"})

-- ============================================================================
-- 3. RECIPE COMPILER & INJECTION HANDLING
-- ============================================================================
local function QuickAddRecipe(prefab, ings, placable, owner)
    local placercfg = prefab.."_placer"
    if placable == nil then
        placercfg = nil
    end
    
    local config = 
    {
        image = prefab..".tex", 
        atlas = "images/inventoryimages/"..prefab..".xml",
        placer = placercfg,
        builder_tag = owner,
    }
    
    AddRecipe2(prefab, ings, LEVEL_SHRINE, config)
end

-- Custom Filter Tab Items (Locked securely on creation)
QuickAddRecipe("lube", { GLOBAL.Ingredient("glommerfuel", 1), GLOBAL.Ingredient("healingsalve", 1) }) 
QuickAddRecipe("stickysalve", { GLOBAL.Ingredient("honey", 2) }) 
QuickAddRecipe("dildo", { GLOBAL.Ingredient("nitre", 2) }) 
QuickAddRecipe("strapon", { GLOBAL.Ingredient("nitre", 2) }) 
QuickAddRecipe("vibrator", { GLOBAL.Ingredient("transistor", 2), GLOBAL.Ingredient("gears", 1) }) 
QuickAddRecipe("buttplug", { GLOBAL.Ingredient("flint", 5), GLOBAL.Ingredient("purplegem", 1) }) 
QuickAddRecipe("buttplug_red", { GLOBAL.Ingredient("flint", 5), GLOBAL.Ingredient("redgem", 1) }) 
QuickAddRecipe("buttplug_blue", { GLOBAL.Ingredient("flint", 5), GLOBAL.Ingredient("bluegem", 1) }) 
QuickAddRecipe("plug_foxtail", { GLOBAL.Ingredient("rope", 1), GLOBAL.Ingredient("beefalowool", 1) }) 
QuickAddRecipe("chaintits", { GLOBAL.Ingredient("flint", 10) }) 
QuickAddRecipe("shadowgoop", { GLOBAL.Ingredient("nightmarefuel", 1) }) 
QuickAddRecipe("towel", { GLOBAL.Ingredient("silk", 1) })
QuickAddRecipe("anticumpen", { GLOBAL.Ingredient("blue_cap", 1), GLOBAL.Ingredient("stinger", 1) })
QuickAddRecipe("boobspen", { GLOBAL.Ingredient("red_cap", 1), GLOBAL.Ingredient("stinger", 1) })
QuickAddRecipe("clearpen", { GLOBAL.Ingredient("petals", 2), GLOBAL.Ingredient("stinger", 1) })
QuickAddRecipe("libidopill", { GLOBAL.Ingredient("red_cap", 1), GLOBAL.Ingredient("blue_cap", 1), GLOBAL.Ingredient("green_cap", 1) })
QuickAddRecipe("antilibidopill", { GLOBAL.Ingredient("green_cap", 3) })
QuickAddRecipe("plantjuice", { GLOBAL.Ingredient("plantmeat", 1) })
QuickAddRecipe("lewddisguisekit", { GLOBAL.Ingredient("mosquitosack", 1), GLOBAL.Ingredient("spidergland", 1) })

-- Base World Structures (Natively mapped so they never vanish)
AddRecipe2("sciencewife", { GLOBAL.Ingredient("boards", 4), GLOBAL.Ingredient("marble", 4), GLOBAL.Ingredient("dildo_gold", 4) }, GLOBAL.TECH.SCIENCE_ONE, { image = "sciencewife.tex", atlas = "images/inventoryimages/sciencewife.xml", placer = "sciencewife_placer" }, {"STRUCTURES"})
AddRecipe2("wormla_whip", { GLOBAL.Ingredient("cutreeds", 3), GLOBAL.Ingredient("stinger", 3) }, GLOBAL.TECH.SCIENCE_ONE, { image = "wormla_whip.tex", atlas = "images/inventoryimages/wormla_whip.xml", builder_tag = "wormla" }, {"WEAPONS"})

-- ============================================================================
-- 4. POST-COMPILATION UI FILTER MAPPING (MUST BE AT THE ABSOLUTE BOTTOM)
-- ============================================================================
local sexrecipes_mapping = {
    "lube", "stickysalve", "dildo", "strapon", "vibrator", "buttplug", 
    "buttplug_red", "buttplug_blue", "plug_foxtail", "shadowgoop", 
    "sciencewife", "towel", "anticumpen", "boobspen", "clearpen", 
    "libidopill", "antilibidopill", "plantjuice", "lewddisguisekit"
}

-- Moving this loop here ensures items are verified as existing before being slotted!
for _, prefab_name in pairs(sexrecipes_mapping) do
    AddRecipeToFilter(prefab_name, "SEX_TAB")
end