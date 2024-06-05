local require = GLOBAL.require
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIFONT = GLOBAL.UIFONT
local STRINGS = GLOBAL.STRINGS

local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

AddMinimapAtlas("images/map_icons/wormla.xml")

AddModCharacter("wormla", "FEMALE", skin_modes)

STRINGS.CHARACTERS.WORMLA = require "speech_wormla"

STRINGS.NAMES.WORMLA = "Wormla"
STRINGS.SKIN_NAMES.wormla_none = "Wormla"

STRINGS.CHARACTER_TITLES.wormla = "The Plant Girl"
STRINGS.CHARACTER_NAMES.wormla = "Wormla"
STRINGS.CHARACTER_DESCRIPTIONS.wormla = "*Plants love her.\n*Her natural love is healing.\n*Have plants friends to help get love.\n*Not very good at fighting."
STRINGS.CHARACTER_QUOTES.wormla = "\"Why pretty friends stare at Wormla?\""
STRINGS.CHARACTER_SURVIVABILITY.wormla = "Slim"