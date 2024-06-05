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

local function UpdateDoll(self)
    if self.lastpart == "head" then
	    self.puppet.animstate:OverrideSymbol("head", self.lastdata, "head")
	    self.puppet.animstate:OverrideSymbol("headbase", self.lastdata, "headbase")
	    self.puppet.animstate:OverrideSymbol("headbase_hat", self.lastdata, "headbase_hat")
	    self.puppet.animstate:OverrideSymbol("cheeks", self.lastdata, "cheeks")
	    self.puppet.animstate:OverrideSymbol("face", self.lastdata, "face")
	    self.puppet.animstate:OverrideSymbol("face_sail", self.lastdata, "face_sail")
	    self.puppet.animstate:OverrideSymbol("hair", self.lastdata, "hair")
	    self.puppet.animstate:OverrideSymbol("hair_hat", self.lastdata, "hair_hat")
	    self.puppet.animstate:OverrideSymbol("hairfront", self.lastdata, "hairfront")	
	    self.puppet.animstate:OverrideSymbol("hairpigtails", self.lastdata, "hairpigtails")
    elseif self.lastpart == "body" then
	    local titsbuild = GetTitsBySize(self.lastdata, self.titssize)	
	    if titsbuild == nil then
	        titsbuild = self.lastdata
	    end		
		self.puppet.animstate:OverrideSymbol("torso", titsbuild, "torso")
	    self.puppet.animstate:OverrideSymbol("arm_upper", self.lastdata, "arm_upper")	
	    self.puppet.animstate:OverrideSymbol("arm_upper_skin", self.lastdata, "arm_upper_skin")
    elseif self.lastpart == "hands" then
		self.puppet.animstate:OverrideSymbol("hand", self.lastdata, "hand")
	    self.puppet.animstate:OverrideSymbol("arm_lower", self.lastdata, "arm_lower")	
	    self.puppet.animstate:OverrideSymbol("arm_lower_cuff", self.lastdata, "arm_lower_cuff")
    elseif self.lastpart == "legs" then
		self.puppet.animstate:OverrideSymbol("leg", self.lastdata, "leg")
	    self.puppet.animstate:OverrideSymbol("torso_pelvis", self.lastdata, "torso_pelvis")	
		if self.dick == "" then
		    self.puppet.animstate:ClearOverrideSymbol("swap_body_tall")
		else
		    self.puppet.animstate:OverrideSymbol("swap_body_tall", self.dick, "swap_body_tall")	
		end
	elseif self.lastpart == "feets" then
	    self.puppet.animstate:OverrideSymbol("foot", self.lastdata, "foot")
	end
	self.puppet.animstate:PlayAnimation("disguiseuidoll_"..self.lastpart, true)
end

local function MakeExtraUI(self)
    if self.extra_ui ~= nil then
		self.extra_ui:Kill()
	end
    if self.lastpart == "body" then
	    if CanChangeBoobsSize(self.lastdata) then
	        self.extra_ui = self.proot:AddChild(CreateTextSpinner("Tits", 
			{ 
	            { text = "None", data = "none" }, 
	            { text = "Flat", data = "flat" }, 
	            { text = "Small", data = "small" },
                { text = "Medium", data = "medium" },	
	            { text = "Large", data = "large" } 
			}))
	        self.extra_ui.OnChanged = function( _, data )
			    self.titssize = data
				UpdateDoll(self)
            end
            self.extra_ui:SetPosition(145, -32)			
		else
		    self.titssize = "none"
			UpdateDoll(self)
		end
	elseif self.lastpart == "legs" then
	    self.extra_ui = self.proot:AddChild(CreateTextSpinner("Tits", 
        { 
	        { text = "None", data = "" },
	        { text = "White", data = "white_dick" },
	        { text = "Brown", data = "walter_dick" },
	       	{ text = "Gray", data = "warly_dick" },
	       	{ text = "Robo", data = "wx78_dick" },
	       	{ text = "Spider", data = "webber_dick" },
	       	{ text = "Spider White", data = "webber_dick_white" },
	       	{ text = "Spider Brown", data = "webber_dick_brown" },
	       	{ text = "Plant", data = "wormla_dick" },
	       	{ text = "Red", data = "wortox_dick" } 
		}))
	    self.extra_ui.OnChanged = function( _, data )
		    self.dick = data
			UpdateDoll(self)
        end
		self.extra_ui:SetPosition(145, -32)
	end
end

local function MakeSkinUI(self, menu_arr)
    if self.skin_ui ~= nil then
		self.skin_ui:Kill()
	end	
	self.skin_ui = self.proot:AddChild(CreateTextSpinner("Skins", menu_arr))
	self.skin_ui:SetPosition(0, -180)
	self.skin_ui.OnChanged = function( _, data )
	    self.lastdata = data
		UpdateDoll(self)
		MakeExtraUI(self)
	end	
end

local LewdDisguiseKit = Class(Screen, function(self)
    Screen._ctor(self, "LewdDisguiseKit")

    TheInput:ClearCachedController()

    self.active = true

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.puppet = self.proot:AddChild(Puppet())
	self.puppet:SetScale(2.7)
	self.puppet:SetPosition(0,-90)
	self.puppet:SetClickable(false)
	self.puppet:SetSkins("wendy", "", {}, true)
	self.puppet.animstate:PlayAnimation("disguiseuidoll_head", true)
	
    self.title = self.proot:AddChild(Text(BUTTONFONT, 50))
    self.title:SetPosition(0, 170, 0)
    self.title:SetColour(1,1,1,1)
	local candidates = GetPossibleDisguiseCandiates(true)
	local nudebuilds = GetNudeBuildOptions(true)
	self.lastpart = "head"
	self.lastdata = candidates[1].data
	self.titssize = "none"
	self.dick = ""
	
	self.title:SetString("What part you want?")
	local parts = {}
	table.insert(parts, { text = "Head", data = "head" })
	table.insert(parts, { text = "Torso", data = "body" })
	table.insert(parts, { text = "Hands", data = "hands" })
	table.insert(parts, { text = "Legs", data = "legs" })
	table.insert(parts, { text = "Feets", data = "feets" })
	MakeSkinUI(self, candidates)
	
	self.partselect_ui = self.proot:AddChild(CreateTextSpinner("Skins", parts))
	self.partselect_ui:SetPosition(0, -140)
	self.partselect_ui.OnChanged = function( _, data )
		self.lastpart = data
		if data ~= "head" then
            self.lastdata = nudebuilds[1].data
			MakeSkinUI(self, nudebuilds)
		else
		    self.lastdata = candidates[1].data
			MakeSkinUI(self, candidates)
		end
		MakeExtraUI(self)
		UpdateDoll(self)
	end
    local subbuttons = {}
    table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })
	table.insert(subbuttons, {text="Take it", cb=function() self:TakeIt() end })
	table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })

    self.submenu = self.proot:AddChild(Menu(subbuttons, button_w, true, "carny_long", nil, 30))
    self.submenu:SetPosition(-170, -220, 0)
	
    for i,v in pairs(self.submenu.items) do
        v:SetScale(.7)
    end
	
	UpdateDoll(self)

    TheInputProxy:SetCursorVisible(true)
    self.default_focus = self.submenu
end)

function LewdDisguiseKit:closemenu()
    SendModRPCToServer(MOD_RPC["LEWD"]["DISKIT"], ThePlayer, "")
	TheInput:CacheController()
	self.active = false
    TheFrontEnd:PopScreen(self)
end

function LewdDisguiseKit:TakeIt()
	SendModRPCToServer(MOD_RPC["LEWD"]["DISKIT"], ThePlayer, self.lastpart, self.lastdata, self.titssize, self.dick)
	self:closemenu()
end

function LewdDisguiseKit:OnControl(control, down)
    if LewdDisguiseKit._base.OnControl(self,control, down) then
       --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	   return true
    end
end

function LewdDisguiseKit:OnBecomeActive()
	LewdDisguiseKit._base.OnBecomeActive(self)
	TheFrontEnd:HideTopFade()
end

return LewdDisguiseKit
