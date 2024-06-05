local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local PopupDialogScreen = require "screens/redux/popupdialog"
local TEMPLATES = require "widgets/redux/templates"
local OptionsScreen = require "screens/redux/optionsscreen"
local Puppet = require "widgets/skinspuppet"

local CharsList = GetActiveCharacterList()
local Curr = 1

local button_w = 160
local button_h = 50

function GetGenderStrings(charactername)
    for gender,characters in pairs(CHARACTER_GENDERS) do
        if table.contains(characters, charactername) then
            return gender
        end
    end
    return "DEFAULT"
end

local label_width = 200
local spinner_width = 220
local spinner_height = 36
local spinner_scale_x = .76
local spinner_scale_y = .68
local narrow_field_nudge = -50
local space_between = 5

local function CreateTextSpinner(labeltext, spinnerdata)    
	local w = TEMPLATES.LabelSpinner(labeltext, spinnerdata, label_width, spinner_width, spinner_height, space_between, nil, nil, narrow_field_nudge)
    return w.spinner
end

local function SortArray(mode)
    if mode == "all" then
	    CharsList = GetActiveCharacterList()
	elseif mode == "girls" then
	    CharsList = {}
		local ForNow = GetActiveCharacterList()
		for x = 1,#ForNow,1 do
			if ForNow[x] ~= nil and GetGenderStrings(ForNow[x]) == "FEMALE" then
				table.insert(CharsList, ForNow[x])
		    end
	    end
    elseif mode == "boys" then
	    CharsList = {}
		local ForNow = GetActiveCharacterList()
		for x = 1,#ForNow,1 do
			if ForNow[x] ~= nil and GetGenderStrings(ForNow[x]) ~= "FEMALE" then
				table.insert(CharsList, ForNow[x])
		    end
	    end     	
	end
end

local function MakeElegantMenu(self)
    self.base_skin = CharsList[Curr].."_none"
	if self.elegant_ui ~= nil then
	    self.elegant_ui:Kill()
	end
	local arr = GetCharacterSkinBases(CharsList[Curr])
	local menu_arr = {}
	local set_ = 0
	local n = 0
	for item_key,_ in pairs(arr) do 
	    n = n+1
        if item_key == CharsList[Curr].."_none"	then
		    set_ = n
		end
        table.insert(menu_arr, { text = item_key, data = item_key })
	end	
	
	self.elegant_ui = self.proot:AddChild(CreateTextSpinner("Skins", menu_arr))
	self.elegant_ui:SetPosition(0, -140)
	self.elegant_ui.OnChanged = function( _, data )
        self.puppet:SetSkins(CharsList[Curr], data, {}, true)
		self.base_skin = data
	end
	self.elegant_ui:SetSelectedIndex(set_)
	if n == 0 then
	    self.elegant_ui:Hide()
	end	
end

local LustBookScreen = Class(Screen, function(self)
    Screen._ctor(self, "LustBookScreen")

    TheInput:ClearCachedController()

    self.active = true

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

	
    self.title = self.proot:AddChild(Text(BUTTONFONT, 50))
    self.title:SetPosition(0, 170, 0)
    self.title:SetColour(1,1,1,1)
	
	--Start
	
	self.title:SetString("Who you want to summon?")
	
    local buttons = {}
    table.insert(buttons, {text="Girl", cb=function() SortArray("girls") self:BeginChoice() end })
	table.insert(buttons, {text="Close Menu", cb=function() self:closemenu() end })
	table.insert(buttons, {text="Boy", cb=function() SortArray("boys") self:BeginChoice() end })

    self.menu = self.proot:AddChild(Menu(buttons, button_w, true, "carny_long", nil, 30))
    self.menu:SetPosition(-170, -190, 0)
	
    for i,v in pairs(self.menu.items) do
        v:SetScale(.7)
    end

    TheInputProxy:SetCursorVisible(true)
    self.default_focus = self.menu
end)

function LustBookScreen:BeginChoice()
    self.menu:Kill()

    Curr = 1
    self.title:SetString(CharsList[1])	

	self.puppet = self.proot:AddChild(Puppet())
	self.puppet:SetScale(2.7)
	self.puppet:SetPosition(0,-90)
	self.puppet:SetClickable(false)
	self.puppet:SetSkins(CharsList[1], CharsList[1].."_none", {}, true)
	self.base_skin = CharsList[1].."_none"
	MakeElegantMenu(self)
	
	local buttons = {}
    table.insert(buttons, {text="Previous", cb=function() self:Previous() end })
	table.insert(buttons, {text="Summon", cb=function() self:Summon() end })
	table.insert(buttons, {text="Next", cb=function() self:Next() end })

    self.menu = self.proot:AddChild(Menu(buttons, button_w, true, "carny_long", nil, 30))
    self.menu:SetPosition(-170, -190, 0)
	
    for i,v in pairs(self.menu.items) do
        v:SetScale(.7)
    end
	
    local subbuttons = {}
    table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })
	table.insert(subbuttons, {text="Unsummon", cb=function() self:UnSummon() end })
	table.insert(subbuttons, {text="Random", cb=function() Curr = math.ceil(math.random(1,#CharsList)) self:Summon() end })

    self.submenu = self.proot:AddChild(Menu(subbuttons, button_w, true, "carny_long", nil, 30))
    self.submenu:SetPosition(-170, -240, 0)
	
    for i,v in pairs(self.submenu.items) do
        v:SetScale(.7)
    end
end

function LustBookScreen:closemenu()
    SendModRPCToServer(MOD_RPC["LEWD"]["CALL"], ThePlayer, "")
	TheInput:CacheController()
	self.active = false
    TheFrontEnd:PopScreen(self)
end

function LustBookScreen:Next()    
	if Curr < #CharsList then	
	    Curr = Curr+1
	    self.title:SetString(CharsList[Curr])
	end
	MakeElegantMenu(self)
	self.puppet:SetSkins(CharsList[Curr], CharsList[Curr].."_none", {}, true)
end

function LustBookScreen:Previous()   
	if Curr > 1 then	
	    Curr = Curr-1
	    self.title:SetString(CharsList[Curr])
	end
	MakeElegantMenu(self)
	self.puppet:SetSkins(CharsList[Curr], CharsList[Curr].."_none", {}, true)
end 

function LustBookScreen:Summon()
    local name = CharsList[Curr]
	
	SendModRPCToServer(MOD_RPC["LEWD"]["CALL"], ThePlayer, name, self.base_skin)
	
	self:closemenu()
end

function LustBookScreen:UnSummon()	
	SendModRPCToServer(MOD_RPC["LEWD"]["CALL"], ThePlayer, "unsummon", nil)
	self:closemenu()
end

function LustBookScreen:OnControl(control, down)
    if LustBookScreen._base.OnControl(self,control, down) then
       --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	   return true
    end
end

function LustBookScreen:OnBecomeActive()
	LustBookScreen._base.OnBecomeActive(self)
	TheFrontEnd:HideTopFade()
end

return LustBookScreen
