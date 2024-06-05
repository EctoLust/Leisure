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

local LewdDialog = Class(Screen, function(self)
    Screen._ctor(self, "LewdDialog")
	
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
    self.CharlieName = self.root:AddChild(Text(TITLEFONT, 35, "Charlie"))
	self.CharlieName:SetPosition(-500, 280)

    self.dialog = self.root:AddChild(TEMPLATES.RectangleWindow(dialog_size_x, dialog_size_y))
    self.dialog:SetPosition(140, 10)
    self.panel_root = self.dialog:InsertWidget(Widget("panel_root"))
    self.panel_root:SetPosition(-120, -41)
    self.title = self.root:AddChild(Text(TITLEFONT, 34, ""))
	self.title:SetPosition(150, 295)
    self.title:SetString("Tutorial")

    self.text = self.root:AddChild(Text(TITLEFONT, 34, ""))
	self.text:SetPosition(150, 200)
    self.text:SetString("Hello and welcome, welcome to the Constant! This is the world of sex and lust!\n I am here to give you some information that you need to realize your lust!")	
	
    local button = {{text = "Continue", cb = function() 
	     DialogNum = DialogNum+1
		 self:DoNext()
	end}}
	
    self.continue_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.continue_btn:SetPosition(150, -100)
	
    local button = {{text = "Skip", cb = function() 
         self:StartEdit()
	end}}
	
    self.skip_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.skip_btn:SetPosition(150, -175)
	
	self.nude_build = GetNudeBuild(ThePlayer.prefab)
	self.base_skin = TheNet:GetClientTableForUser(ThePlayer.userid).base_skin
	--print(self.nude_build)
	
	if GetGenderStrings(ThePlayer.prefab) == "FEMALE" then
	    self.dick = "none"
		self.tits = GetDefaultTitsSize(ThePlayer.prefab)
	else
	    self.dick = GetDefaultDick(ThePlayer.prefab, self.base_skin)
		self.tits = ""
	end
	
	self.charlie = self.root:AddChild(UIAnim())
	self.charlie:SetPosition(-500, -300)
	self.charlie:SetScale(0.47)
    self.charlie:GetAnimState():SetBank("CharlieUi")
	self.charlie:GetAnimState():SetBuild("CharlieUi")
    self.charlie:GetAnimState():PlayAnimation("Idle", true)
	
	self.puppet = self.root:AddChild(Puppet())
	self.puppet:SetPosition(150,0)
	self.puppet:SetScale(3)
	self.puppet:SetClickable(false)
	--self.puppet:SetCharacter(ThePlayer.prefab)
	self.puppet:Hide()
	self.puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true)
	--self:SetNude()
	
	self.nudebuildoptions = GetNudeBuildOptions(false)
	
	if TUNING.TUTORIAL_SKIP == 1 then
	    self:StartEdit()
	end
end)

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

local NameToIndex = {}
NameToIndex["none"] = 1
NameToIndex[""] = 1
NameToIndex["flat"] = 2
NameToIndex["small"] = 3
NameToIndex["medium"] = 4
NameToIndex["large"] = 5
-----------------------------
NameToIndex["white_dick"] = 2
NameToIndex["walter_dick"] = 3
NameToIndex["warly_dick"] = 4
NameToIndex["wx78_dick"] = 5
NameToIndex["webber_dick"] = 6
NameToIndex["webber_dick_white"] = 7
NameToIndex["webber_dick_brown"] = 8
NameToIndex["wormla_dick"] = 9
NameToIndex["wortox_dick"] = 10
-----------------------------
NameToIndex["wendy_nude"] = 2
NameToIndex["male_nude"] = 3
NameToIndex["male_nude_brown"] = 4
NameToIndex["wanda_nude"] = 5
NameToIndex["male_nude_gray"] = 6
NameToIndex["wormla_nude"] = 7

function LewdDialog:ReCreateTitsSelect()
	if self.tits_ui ~= nil then
	    self.tits_ui:Kill()
	end
	
	if CanChangeBoobsSize(self.nude_build) then
	    self.tits_ui = self.root:AddChild(CreateTextSpinner("Tits", { 
	    { text = "None", data = "none" }, 
	    { text = "Flat", data = "flat" }, 
	    { text = "Small", data = "small" },
        { text = "Medium", data = "medium" },	
	    { text = "Large", data = "large" } }))
	else
	    self.tits_ui = self.root:AddChild(CreateTextSpinner("Tits", { -- For characters that already naked by default.
	    { text = "Locked", data = "none" } })) 
	end
	
	self.tits_ui:SetPosition(-75, -100)
	self.tits_ui.OnChanged = function( _, data )
	    self.tits = data
		self:SetTits(self.tits)
	end
	self.tits_ui:SetSelectedIndex(NameToIndex[self.tits])
end

function LewdDialog:ReCreateTitsSelectDisguise()
	if self.tits_ui_disguise ~= nil then
	    self.tits_ui_disguise:Kill()
	end
	
	if CanChangeBoobsSize(self.nude_build_disguise) then
	    self.tits_ui_disguise = self.root:AddChild(CreateTextSpinner("Tits", { 
	    { text = "None", data = "none" }, 
	    { text = "Flat", data = "flat" }, 
	    { text = "Small", data = "small" },
        { text = "Medium", data = "medium" },	
	    { text = "Large", data = "large" } }))
	else
	    self.tits_ui_disguise = self.root:AddChild(CreateTextSpinner("Tits", { -- For characters that already naked by default.
	    { text = "Locked", data = "none" } })) 
	end
	
	self.tits_ui_disguise:SetPosition(-75, -100)
	self.tits_ui_disguise.OnChanged = function( _, data )
	    self.tits_disguise = data
		self:ApplyDisguise(self.selected_disguise)
	end
	self.tits_ui_disguise:SetSelectedIndex(NameToIndex[self.tits_disguise])
end

local CharsList = GetActiveCharacterList()

function LewdDialog:ApplyDisguise(prefab, skipanimchange)
	self:SetSymbolTintDis("arm_upper_skin")
	self:SetSymbolTintDis("arm_upper")
	self:SetSymbolTintDis("hand")
	self:SetSymbolTintDis("arm_lower")
	self:SetSymbolTintDis("arm_lower_cuff")
	self:SetSymbolTintDis("leg")
	self:SetSymbolTintDis("torso")
	self:SetSymbolTintDis("torso_pelvis")
	self:SetSymbolTintDis("foot")
	self:SetSymbolTintDis("dick")
	if prefab == "" then
		self.puppet.animstate:ClearOverrideSymbol("head")
		self.puppet.animstate:ClearOverrideSymbol("headbase")
		self.puppet.animstate:ClearOverrideSymbol("headbase_hat")
		self.puppet.animstate:ClearOverrideSymbol("cheeks")
		self.puppet.animstate:ClearOverrideSymbol("face")
		self.puppet.animstate:ClearOverrideSymbol("face_sail")
		self.puppet.animstate:ClearOverrideSymbol("hair")
		self.puppet.animstate:ClearOverrideSymbol("hair_hat")
		self.puppet.animstate:ClearOverrideSymbol("hairfront")
		self.puppet.animstate:ClearOverrideSymbol("hairpigtails")	    
		self.puppet:SetCharacter(ThePlayer.prefab)
		self.puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true)
		self:SetNude()
		self.dick_text:Hide()
		self.dick_ui_disguise:Hide()
		self.nude_text:Hide()
	    self.nude_custom_disguise:Hide()
		self.tits_text:Hide()
		self.tits_ui_disguise:Hide()
		self.tint_text:Hide()
		self.tint_r_dis:Hide()
		self.tint_g_dis:Hide()
		self.tint_b_dis:Hide()
		self.tint_r_field_dis:Hide()
		self.tint_g_field_dis:Hide()
		self.tint_b_field_dis:Hide()
		self.tint_r_field_dis.done_btn:Hide()
		self.tint_g_field_dis.done_btn:Hide()
		self.tint_b_field_dis.done_btn:Hide()
		return
	end
	self.dick_text:Show()
	self.dick_ui_disguise:Show()
	self.nude_text:Show()
	self.nude_custom_disguise:Show()
	self.tits_text:Show()
	self.tits_ui_disguise:Show()
	self.tint_text:Show()
	self.tint_r_dis:Show()
	self.tint_g_dis:Show()
	self.tint_b_dis:Show()
	if self.tint_r_field_dis.editmode then
		self.tint_r_field_dis:Show()
	end
	if self.tint_g_field_dis.editmode then
		self.tint_g_field_dis:Show()
	end
	if self.tint_b_field_dis.editmode then
		self.tint_b_field_dis:Show()
	end
	self.tint_r_field_dis.done_btn:Show()
	self.tint_g_field_dis.done_btn:Show()
	self.tint_b_field_dis.done_btn:Show()
    local build = self.nude_build_disguise
	if build == nil or build == "" then
	    build = prefab
	end
	local titssize = self.tits_disguise
	local titsbuild = GetTitsBySize(prefab, titssize)	
	if titsbuild == nil then
	    titsbuild = build
	end
	
	self.puppet.animstate:OverrideSymbol("torso", build, "torso")
	self.puppet.animstate:OverrideSymbol("arm_upper_skin", build, "arm_upper_skin")	
	self.puppet.animstate:OverrideSymbol("arm_upper", build, "arm_upper")	
	self.puppet.animstate:OverrideSymbol("hand", build, "hand")
	self.puppet.animstate:OverrideSymbol("arm_upper_skin", build, "arm_upper_skin")	
	self.puppet.animstate:OverrideSymbol("arm_lower", build, "arm_lower")	
	self.puppet.animstate:OverrideSymbol("arm_lower_cuff", build, "arm_lower_cuff")	
	self.puppet.animstate:OverrideSymbol("leg", build, "leg")
	self.puppet.animstate:OverrideSymbol("skirt", build, "skirt")
	self.puppet.animstate:OverrideSymbol("torso_pelvis", build, "torso_pelvis")	
	self.puppet.animstate:OverrideSymbol("foot", build, "foot")	
	self.puppet.animstate:OverrideSymbol("torso", titsbuild, "torso")
	
	local headbuild = prefab
	self.puppet.animstate:OverrideSymbol("head", headbuild, "head")
	self.puppet.animstate:OverrideSymbol("headbase", headbuild, "headbase")
	self.puppet.animstate:OverrideSymbol("headbase_hat", headbuild, "headbase_hat")
	self.puppet.animstate:OverrideSymbol("cheeks", headbuild, "cheeks")
	self.puppet.animstate:OverrideSymbol("face", headbuild, "face")
	self.puppet.animstate:OverrideSymbol("face_sail", headbuild, "face_sail")
	self.puppet.animstate:OverrideSymbol("hair", headbuild, "hair")
	self.puppet.animstate:OverrideSymbol("hair_hat", headbuild, "hair_hat")
	self.puppet.animstate:OverrideSymbol("hairfront", headbuild, "hairfront")	
	self.puppet.animstate:OverrideSymbol("hairpigtails", headbuild, "hairpigtails")
	
	if skipanimchange == nil then
		if self.dick_disguise == "" then
	        self.puppet.animstate:PlayAnimation("fap_loop_girl_new_new", true)
		    self.puppet.animstate:ClearOverrideSymbol("dick")
	    else
	        self.puppet.animstate:OverrideSymbol("dick", self.dick_disguise, "dick")
	        self.puppet.animstate:PlayAnimation("fap_loop_new_new", true)
	    end	
	end
end

function LewdDialog:StartDisguise()
    self.tint_dis = {r = 1, g = 1, b = 1}
	self.selected_disguise = ""
	self.nude_build_disguise = GetNudeBuild(ThePlayer.prefab)
	if GetGenderStrings(ThePlayer.prefab) == "FEMALE" then
	    self.dick_disguise = "none"
		self.tits_disguise = GetDefaultTitsSize(ThePlayer.prefab)
	else
	    self.dick_disguise = GetDefaultDick(ThePlayer.prefab, self.base_skin)
		self.tits_disguise = ""
	end	
	
	self.tits_text:Hide()
	self.dick_text:Hide()
	self.nude_text:Hide()
	self.nude_custom:Hide()
	self.dick_ui:Hide()
	self.done_btn:Hide()
	self.tits_ui:Hide()
	
	CharsList = GetActiveCharacterList()
	
	local button = {{text = "Done", cb = function() 
         self:Done()
	end}}
	
		local tintnumbers = {}
	for i = 0, 255, 1 do
	    table.insert(tintnumbers, {text = i, data = i / 255})
	end
	local tintY = 35
	self.tint_r_dis = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_r_dis:SetPosition(325, tintY)
	self.tint_r_dis:SetSelectedIndex(256)
	self.tint_r_dis.OnChanged = function( _, data )
		self.tint_dis.r = data
		self:ApplyDisguise(self.selected_disguise, true)
	end
	self.tint_r_field_dis = self:CreateTextBox(325, tintY, self.tint_r_dis)
	self.tint_g_dis = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_g_dis:SetPosition(325, tintY-30)
	self.tint_g_dis:SetSelectedIndex(256)
    self.tint_g_dis.OnChanged = function( _, data )
		self.tint_dis.g = data
		self:ApplyDisguise(self.selected_disguise, true)
	end
	self.tint_g_field_dis = self:CreateTextBox(325, tintY-30, self.tint_g_dis)
	self.tint_b_dis  = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_b_dis :SetPosition(325, tintY-60)
	self.tint_b_dis :SetSelectedIndex(256)
	self.tint_b_dis .OnChanged = function( _, data )
		self.tint_dis.b = data
		self:ApplyDisguise(self.selected_disguise, true)
	end
	self.tint_b_field_dis = self:CreateTextBox(325, tintY-60, self.tint_b_dis)
	self.done2_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.done2_btn:SetPosition(150, -175)
	self.disguise_text = self.root:AddChild(Text(TITLEFONT, 34, "Disguise as"))
	self.disguise_text:SetPosition(-75, 100)
	local SpinerData = GetPossibleDisguiseCandiates()
	self.dick_ui_disguise = self.root:AddChild(CreateTextSpinner("Dick", { 
	{ text = "None", data = "" },
	{ text = "White", data = "white_dick" },
	{ text = "Brown", data = "walter_dick" },
	{ text = "Gray", data = "warly_dick" },
	{ text = "Robo", data = "wx78_dick" },
	{ text = "Spider", data = "webber_dick" },
	{ text = "Spider White", data = "webber_dick_white" },
	{ text = "Spider Brown", data = "webber_dick_brown" },
	{ text = "Plant", data = "wormla_dick" },
	{ text = "Red", data = "wortox_dick" } }))
	self.dick_ui_disguise:SetPosition(325, -100)
	self.dick_ui_disguise.OnChanged = function( _, data )
	    self.dick_disguise = data
		self:ApplyDisguise(self.selected_disguise)
	end
	
	self.nude_custom_disguise = self.root:AddChild(CreateTextSpinner("Nude skin", self.nudebuildoptions))
    self.nude_custom_disguise:SetPosition(-75, 0)	
	self.nude_custom_disguise.OnChanged = function( _, data )
		self.nude_build_disguise = data
		if data == "male_nude" then
		    self.tits_disguise = "none"
		end
		if CanChangeBoobsSize(self.nude_build_disguise) == false then
		    self.tits_disguise = "none"
		end
		if data == "wendy_nude" then
		    self.tits_disguise = GetDefaultTitsSize(self.selected_disguise)
		end
		self:ReCreateTitsSelectDisguise()
		self:ApplyDisguise(self.selected_disguise)
	end
	self:ReCreateTitsSelectDisguise()
	self.disguise_select = self.root:AddChild(CreateTextSpinner("Disguise", SpinerData))
    self.disguise_select:SetPosition(-75, 65)	
	self.disguise_select.OnChanged = function( _, data )	
		self.selected_disguise = data
	    if GetGenderStrings(self.selected_disguise) ~= "FEMALE" then	
	        self.dick_disguise = GetDefaultDick(self.selected_disguise)
			self.dick_ui_disguise:SetSelectedIndex(NameToIndex[self.dick_disguise])
		else
	        self.dick_disguise = ""
			self.dick_ui_disguise:SetSelectedIndex(NameToIndex[self.dick_disguise])
	    end
		if self.selected_disguise == "" then
		    self.nude_build_disguise = GetNudeBuild(ThePlayer.prefab)
		else
		    self.nude_build_disguise = GetNudeBuild(self.selected_disguise)
		end
		self.nude_custom_disguise:SetSelectedIndex(NameToIndex[self.nude_build_disguise])
		if self.nude_build_disguise == "male_nude" then
		    self.tits_disguise = "none"
		end
		if CanChangeBoobsSize(self.nude_build_disguise) == false then
		    self.tits_disguise = "none"
		end
		if self.nude_build_disguise == "wendy_nude" then
		    self.tits_disguise = GetDefaultTitsSize(self.selected_disguise)
		end
		self:ReCreateTitsSelectDisguise()		
		self:ApplyDisguise(data)
	end
	self:ApplyDisguise(self.selected_disguise)
	self.tint_r:Hide()
	self.tint_g:Hide()
	self.tint_b:Hide()
	self.tint_text:Hide()
	self.tint_r_field.done_btn:Hide()
	self.tint_g_field.done_btn:Hide()
	self.tint_b_field.done_btn:Hide()
	
end

function LewdDialog:CreateTextBox(x, y, spiner)
    local textentry_width = 180
	local textentry_height = 30
	local textentry = self.root:AddChild(TEMPLATES.StandardSingleLineTextEntry(nil, textentry_width, textentry_height, NEWFONT, 18, ""))
	textentry.editmode = false
	textentry:SetPosition(x, y)
    --textentry.changed_image = textentry:AddChild(Image("images/global_redux.xml", "option_highlight.tex"))
    --textentry.changed_image:SetPosition(0, 0)
    --textentry.changed_image:ScaleToSizeIgnoreParent(textentry_width + 28, 50)
    --textentry.changed_image:MoveToBack()
    --textentry.changed_image:SetClickable(false)
    --textentry.changed_image:SetTint(1,1,1,0.3)
	textentry.done_btn = self.root:AddChild(TEMPLATES.StandardButton(nil, "Modify", {50, 30}))
	local onclick = function()
	    if textentry.editmode then
		    textentry.editmode = false
		else
		    textentry.editmode = true
		end
		
		if textentry.editmode then
		    textentry.done_btn:SetText("Apply")
			textentry:Show()
			spiner:Hide()
			spiner:Hide()
			textentry.textbox:SetString(spiner:GetText())
		else
		    textentry.done_btn:SetText("Modify")
			spiner:Show()
			textentry:Hide()
			local num = tonumber(textentry.textbox:GetString())
			if num then
			    num = num+1
				if num < 1 then
				    num = 1
				else
				    if num > 256 then
					    num = 256
					end
				end
			else
			    num = 256
			end
			local setnum = num-1
			spiner:SetSelectedIndex(num)
			spiner.OnChanged(nil, setnum/255)
		end
	end
	
	textentry.done_btn:SetOnClick(onclick)
	textentry.done_btn:SetPosition(x+130, y)
	textentry:Hide()
	return textentry
end

function LewdDialog:StartEdit()
    self.title:SetString("Character edit")
	self.text:Kill()
	self.continue_btn:Kill()
	self.skip_btn:Kill()
	self.puppet:Show()
	
	self.tint = {r = 1, g = 1, b = 1}
	
    self.tits_text = self.root:AddChild(Text(TITLEFONT, 34, "Tits Size"))
	self.tits_text:SetPosition(-75, -65)
	
    self.dick_text = self.root:AddChild(Text(TITLEFONT, 34, "Dick"))
	self.dick_text:SetPosition(325, -65)
	
    self.nude_text = self.root:AddChild(Text(TITLEFONT, 34, "Nude skin"))
	self.nude_text:SetPosition(-75, 35)	
	
	self.nude_custom = self.root:AddChild(CreateTextSpinner("Nude skin", self.nudebuildoptions))
    self.nude_custom:SetPosition(-75, 0)	
	self.nude_custom.OnChanged = function( _, data )
		self.nude_build = data
		if data == "male_nude" then
		    self.tits = "none"
		end
		if CanChangeBoobsSize(self.nude_build) == false then
		    self.tits = "none"
		end
		if data == "wendy_nude" then
		    self.tits = GetDefaultTitsSize(ThePlayer.prefab)
		end		
		self:ReCreateTitsSelect()
		self:SetNude()
	end
    self.nude_custom:SetSelectedIndex(NameToIndex[self.nude_build])	
	
	self:ReCreateTitsSelect()
	
	--print("Seting spinners.... ")
	
	--print("Tits "..self.tits)
	--print("Tits to index "..NameToIndex[self.tits])
	
	self.dick_ui = self.root:AddChild(CreateTextSpinner("Dick", { 
	{ text = "None", data = "none" }, 
	{ text = "White", data = "white_dick" },
	{ text = "Brown", data = "walter_dick" },
	{ text = "Gray", data = "warly_dick" },
	{ text = "Robo", data = "wx78_dick" },
	{ text = "Spider", data = "webber_dick" },
	{ text = "Spider White", data = "webber_dick_white" },
	{ text = "Spider Brown", data = "webber_dick_brown" },
	{ text = "Plant", data = "wormla_dick" },
	{ text = "Red", data = "wortox_dick" } }))
	self.dick_ui:SetPosition(325, -100)
	self.dick_ui.OnChanged = function( _, data )
	    self.dick = data
		self:SetNude()
	end
	self.dick_ui.OnChanged = function( _, data )
	    self.dick = data
		self:SetNude()
	end
	--print("Dick "..self.dick)
	--print("Dick to index "..NameToIndex[self.dick])
	self.dick_ui:SetSelectedIndex(NameToIndex[self.dick])
	
	local tintnumbers = {}
	for i = 0, 255, 1 do
	    table.insert(tintnumbers, {text = i, data = i / 255})
	end
	local tintY = 35
	self.tint_r = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_r:SetPosition(325, tintY)
	self.tint_r:SetSelectedIndex(256)
	self.tint_r.OnChanged = function( _, data)
		self.tint.r = data
		self:SetNude(true)
	end
	self.tint_r_field = self:CreateTextBox(325, tintY, self.tint_r)
	self.tint_g = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_g:SetPosition(325, tintY-30)
	self.tint_g:SetSelectedIndex(256)
    self.tint_g.OnChanged = function( _, data )
		self.tint.g = data
		self:SetNude(true)
	end
	self.tint_g_field = self:CreateTextBox(325, tintY-30, self.tint_g)
	self.tint_b = self.root:AddChild(CreateTextSpinner("Tint", tintnumbers))
	self.tint_b:SetPosition(325, tintY-60)
	self.tint_b:SetSelectedIndex(256)
	self.tint_b.OnChanged = function( _, data )
		self.tint.b = data
		self:SetNude(true)
	end
	self.tint_b_field = self:CreateTextBox(325, tintY-60, self.tint_b)
	self.tint_text = self.root:AddChild(Text(TITLEFONT, 34, "Custom Color"))
	self.tint_text:SetPosition(325, tintY+35)
	
	
	self:SetNude()
    local button = {{text = "Next", cb = function() 
         --self:Done()
		 self:StartDisguise()
	end}}
	
    self.done_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.done_btn:SetPosition(150, -175)
end

function LewdDialog:DoNext()
    local d = DialogNum
    if d == 1 then
	    self.skip_btn:Hide()
	    self.text:SetString("This mod allow you to have sex alone, with other players and with some monsters.\n Mod have some keybinds: Z - Very close zoom. N - Open nude menu. P - Open poses menu at sex.")
	elseif d == 2 then
	    self.text:SetString("You can use nude menu to remove clothes (skins included) from your character.\n Also wardrobe now have small chest with stockings that you can use.")
	elseif d == 3 then
	    self.text:SetString("To have sex with character just hover mouse on them and press mouse button.\n Then to change pose press P button and change pose.")
	elseif d == 4 then
	    self.text:SetString("Some monsters like a spiders or merms now not try kill you, but will catch you to fuck.\n To release yourself from them hit Space button.")
	elseif d == 5 then
	    self.text:SetString("Also some moneters like a bunnymans and pigmans you can feed with food to have frienly sex with thems.")
	elseif d == 6 then
	    self.text:SetString("Here is tutorial is over, Now if you want you can edit your character if you want.")
	elseif d == 7 then
	    self:StartEdit()
	end
end

function LewdDialog:SetTits(tits)
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

function LewdDialog:SetSymbolTint(symbol)
	local tint = self.tint
	if self.nude_build == "" then
	    tint = {r = 1, g = 1, b = 1}
	end
	self.puppet.animstate:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
end

function LewdDialog:SetSymbolTintDis(symbol)
	local tint = self.tint_dis
	if self.selected_disguise == "" then
	    self:SetSymbolTint(symbol)
		return
	end
	self.puppet.animstate:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1)
end

function LewdDialog:SetNude(skipanimchange)
    local puppet = self.puppet
	self:SetSymbolTint("arm_upper_skin")
	self:SetSymbolTint("arm_upper")
	self:SetSymbolTint("hand")
	self:SetSymbolTint("arm_lower")
	self:SetSymbolTint("arm_lower_cuff")
	self:SetSymbolTint("leg")
	self:SetSymbolTint("torso")
	self:SetSymbolTint("torso_pelvis")
	self:SetSymbolTint("foot")
	self:SetSymbolTint("dick")
	if skipanimchange == nil then
		if self.dick == "none" then
	        puppet.animstate:PlayAnimation("fap_loop_girl_new_new", true)
		    self.puppet.animstate:ClearOverrideSymbol("dick")
	    else
	        puppet.animstate:OverrideSymbol("dick", self.dick, "dick")
	        puppet.animstate:PlayAnimation("fap_loop_new_new", true)
	    end
	end
	
	if self.nude_build == "" then -- If already originaly naked characters stop here.
	    self.puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true)
		self.tint_r:Hide()
		self.tint_g:Hide()
		self.tint_b:Hide()
		self.tint_text:Hide()
		self.tint_r_field:Hide()
		self.tint_g_field:Hide()
		self.tint_b_field:Hide()
		self.tint_r_field.done_btn:Hide()
		self.tint_g_field.done_btn:Hide()
		self.tint_b_field.done_btn:Hide()
	    return false
	end
	if self.tint_dis == nil then
	    self.tint_r:Show()
	    self.tint_g:Show()
	    self.tint_b:Show()
		if self.tint_r_field.editmode then
		    self.tint_r_field:Show()
		end
		if self.tint_g_field.editmode then
		    self.tint_g_field:Show()
		end
		if self.tint_b_field.editmode then
		    self.tint_b_field:Show()
		end
		self.tint_r_field.done_btn:Show()
		self.tint_g_field.done_btn:Show()
		self.tint_b_field.done_btn:Show()
	    self.tint_text:Show()
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

function LewdDialog:Done() 
    TheFrontEnd:FadeBack(nil, nil, function()
	-- print("Tits "..self.tits)	
	-- print("Dick "..self.dick)
	-- print("Nude skin "..self.nude_build)
	SendModRPCToServer(MOD_RPC["LEWD"]["SPAWNED"], ThePlayer, self.tits, self.dick, self.nude_build, self.selected_disguise, self.dick_disguise, self.nude_build_disguise, self.tits_disguise, 
	self.tint.r, 
	self.tint.g,
	self.tint.b,
	self.tint_dis.r,
	self.tint_dis.g,
	self.tint_dis.b)
    TheInput:CacheController()
	self.active = false 
	TheFrontEnd:PopScreen(self)
	end)	
end

return LewdDialog
