local Screen = require "widgets/screen"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local OnlineStatus = require "widgets/onlinestatus"
local Subscreener = require "screens/redux/subscreener"
local TEMPLATES = require "widgets/redux/templates"
local Button = require "widgets/button"
local Menu = require "widgets/menu"
local Puppet = require "widgets/skinspuppet"
local UIAnim = require "widgets/uianim"


require("characterutil")
require("constants")

local column_offsets
if JapaneseOnPS4() then
     column_offsets ={
        DECEASED = -170,
        DAYS_LIVED = -40,
        CAUSE = 190,
        MODE = 610,
    }
else
    column_offsets ={
        DECEASED = -170,
        DAYS_LIVED = -40,
        CAUSE = 190,
        MODE = 610,
    }
end

local font_face = CHATFONT
local font_size = 28
if JapaneseOnPS4() then
    font_size = 28 * 0.75;
end
local title_font_size = font_size*.8
local title_font_face = HEADERFONT

local units_per_row = 2
local header_height = 330
local num_rows = math.ceil(22 / units_per_row)
local text_content_y = -12 * (units_per_row - 1)
local text_align = ANCHOR_LEFT
if units_per_row == 1 then
    text_align = ANCHOR_MIDDLE
end
local dialog_size_x = 830
local dialog_width = dialog_size_x + (60*2)
local row_height = 30 * units_per_row
local row_width = dialog_width*0.9
local dialog_size_y = row_height*(num_rows + 0.25)

local column_widths = {
    DAYS_LIVED = 120,
    DECEASED = row_height,
    CAUSE = 230,
    MODE = 410,
}

local DialogNum = 0

local LewdWatch = Class(Screen, function(self, arrx)
    Screen._ctor(self, "LewdWatch")
	
	DialogNum = 0
	
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,1) 

    self.root = self:AddChild(TEMPLATES.ScreenRoot("ROOT"))
    self.bg = self.root:AddChild(TEMPLATES.PlainBackground())

    self.dialog = self.root:AddChild(TEMPLATES.RectangleWindow(dialog_size_x, dialog_size_y))
    self.dialog:SetPosition(140, 10)
    self.panel_root = self.dialog:InsertWidget(Widget("panel_root"))
    self.panel_root:SetPosition(-120, -41)
    self.title = self.root:AddChild(Text(TITLEFONT, 34, ""))
	self.title:SetPosition(150, 295)
    self.title:SetString("Watch")
	
    self.error = self.root:AddChild(Text(TITLEFONT, 80, ""))
	self.error:SetPosition(150, 0)
    self.error:SetString("This animation not unlocked yet.")
	self.error:Hide()
	
	self.nude_build = GetNudeBuild(ThePlayer.prefab)
	self.base_skin = TheNet:GetClientTableForUser(ThePlayer.userid).base_skin
	--print(self.nude_build)
	
	if GetGenderStrings(ThePlayer.prefab) == "FEMALE" then
	    self.dick = ""
		self.tits = GetDefaultTitsSize(ThePlayer.prefab)
	else
	    self.dick = GetDefaultDick(ThePlayer.prefab, self.base_skin)
		self.tits = ""
	end
	
	self.puppet = self.root:AddChild(Puppet())
	self.puppet:SetPosition(150,0)
	self.puppet:SetScale(3)
	self.puppet:SetClickable(false)
	--self.puppet:SetCharacter(ThePlayer.prefab)
	self.puppet:Hide()
	self.puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true)
	self:SetNude()
	
	
    local button = {{text = "Back", cb = function() 
         TheInput:CacheController()
	     self.active = false 
	     TheFrontEnd:PopScreen(self)
	end}}
	
    self.done_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.done_btn:SetPosition(150, -175)
	
	local class = LEWD_CATALOG[arrx]["group"]
	
	local function PlayAnim(x)
	    if not Profile:LewdAnimUnlocked(LEWD_CATALOG[x]["anim"]) then
	        self.puppet:Hide()
		    self.error:Show()		
		    return false
		else
	        self.puppet:Show()
		    self.error:Hide()		    
		end
		
		if class ~= "Dildos" then	
	        self.puppet.animstate:PlayAnimation(LEWD_CATALOG[x]["anim"], true)
		else
		    if LEWD_CATALOG[x]["anim"] == "vibrating" then			    
				self.puppet.animstate:PlayAnimation("vibrating", true)
			else
			    self.puppet.animstate:PlayAnimation("dilding", true)
			end
			self.puppet.animstate:OverrideSymbol("dick_other", LEWD_CATALOG[x]["build"], "dick")
		end
	
		if class ~=	"Spiders" and class ~= "Dildos" then
		    self.puppet.animstate:AddOverrideBuild(LEWD_CATALOG[x]["build"])
		elseif class ==	"Spiders" then
			self.puppet.animstate:OverrideSymbol("leg_s", "spider_build", "leg")
			self.puppet.animstate:OverrideSymbol("face_s", "spider_build", "face")
			self.puppet.animstate:OverrideSymbol("body", "spider_build", "body")
		end
	            
        if class ==	"Pigmans & Merms" then
			self.puppet.animstate:OverrideSymbol("dick_other", "pig_dick", "dick")
		elseif class ==	"Bunnyman" then
			self.puppet.animstate:OverrideSymbol("dick_other", "bunny_dick", "dick")
		elseif class ==	"Hounds" then
			self.puppet.animstate:OverrideSymbol("dick_other", "wortox_dick", "dick")
		elseif class ==	"Shadowhands" then
			self.puppet.animstate:AddOverrideBuild("shadow_hands")				
        end		
	end
	PlayAnim(arrx)
	local howmanyanims = 0
	local buttons = {}
	local need_disable = {}
	for x = 1, #LEWD_CATALOG, 1 do 
	    if LEWD_CATALOG[x]["group"] == class then
		    howmanyanims = howmanyanims+1
			if not Profile:LewdAnimUnlocked(LEWD_CATALOG[x]["anim"]) then
				table.insert(need_disable, ""..howmanyanims)
				--print("Gonna disalbe "..howmanyanims.." is "..LEWD_CATALOG[x]["anim"])
			end
			table.insert(buttons, {text=howmanyanims, cb=function()PlayAnim(x)end})
		end
	end
    self.menu = self.root:AddChild(Menu(buttons, -50, false, "carny_long", nil, 30))
    self.menu:SetPosition(-500, 280)
	
	for i,v in pairs(self.menu.items) do
	    for x = 1, #need_disable, 1 do 
		    if v:GetText() == need_disable[x] then
		        v:Disable()
	        end
        end		
	end
end)

function LewdWatch:SetTits(tits)
	local puppet = self.puppet
	
	if self.nude_build == "" then
	    return false
	end
	
	local build = GetTitsBySize(ThePlayer.prefab, tits)	
	--print(tits)
	if build == nil then
	    build = self.nude_build
	end
	
	puppet.animstate:OverrideSymbol("torso", build, "torso")
end

function LewdWatch:SetNude()
    local puppet = self.puppet
	
	if GetGenderStrings(ThePlayer.prefab) == "FEMALE" then
	    puppet.animstate:PlayAnimation("fap_loop_girl_new_new", true)
	else
	    puppet.animstate:OverrideSymbol("dick", self.dick, "dick")
	    puppet.animstate:PlayAnimation("fap_loop_new_new", true)
	end
	
	if self.nude_build == "" then -- If already originaly naked characters stop here.
	    return false
	end
	
	self:SetTits(self.tits)
	puppet.animstate:OverrideSymbol("arm_upper_skin", self.nude_build, "arm_upper_skin")	
	puppet.animstate:OverrideSymbol("arm_upper", self.nude_build, "arm_upper")	
	puppet.animstate:OverrideSymbol("hand", self.nude_build, "hand")
	puppet.animstate:OverrideSymbol("arm_upper_skin", self.nude_build, "arm_upper_skin")	
	puppet.animstate:OverrideSymbol("arm_lower", self.nude_build, "arm_lower")	
	puppet.animstate:OverrideSymbol("arm_lower_cuff", self.nude_build, "arm_lower_cuff")	
	puppet.animstate:OverrideSymbol("leg", self.nude_build, "leg")
	puppet.animstate:OverrideSymbol("skirt", self.nude_build, "skirt")
	puppet.animstate:OverrideSymbol("torso_pelvis", self.nude_build, "torso_pelvis")	
	puppet.animstate:OverrideSymbol("foot", self.nude_build, "foot")
end

return LewdWatch
