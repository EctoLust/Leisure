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
	
    local intro_buttons = {
        {text = "Continue", cb = function() 
             DialogNum = DialogNum+1
             self:DoNext()
        end},
        {text = "Skip", cb = function() 
             self:StartEdit()
        end}
    }
	
    self.intro_menu = self.root:AddChild(Menu(intro_buttons, 75, false, "carny_xlong", nil, 30))
    self.intro_menu:SetPosition(150, -100)
	
	self.nude_build = GetNudeBuild(ThePlayer.prefab)
	self.base_skin = TheNet:GetClientTableForUser(ThePlayer.userid).base_skin
	
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
	self.puppet:Hide()
	self.puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true)
	
	self.nudebuildoptions = GetNudeBuildOptions(false)
	
	if TUNING.TUTORIAL_SKIP == 1 then
	    self:StartEdit()
    else
        if TheInput:ControllerAttached() and self.intro_menu then
            self.intro_menu:SetFocus()
        end
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
    return w, w.spinner 
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
NameToIndex["whisky_nude"] = 8

function LewdDialog:ReCreateTitsSelect()
	if self.tits_ui_widget ~= nil then
	    self.tits_ui_widget:Kill()
	end
	
    local widget, spinner
    if CanChangeBoobsSize(self.nude_build) then
        widget, spinner = CreateTextSpinner("Tits", { 
        { text = "None", data = "none" }, 
        { text = "Flat", data = "flat" }, 
        { text = "Small", data = "small" },
        { text = "Medium", data = "medium" },	
        { text = "Large", data = "large" } })
    else
        widget, spinner = CreateTextSpinner("Tits", { 
        { text = "Locked", data = "none" } }) 
    end
    
    self.tits_ui_widget = self.root:AddChild(widget)
    self.tits_ui = spinner
    self.tits_ui_widget:SetPosition(-75, -100)
	self.tits_ui.OnChanged = function( _, data )
	    self.tits = data
		self:SetTits(self.tits)
	end
	self.tits_ui:SetSelectedIndex(NameToIndex[self.tits])
    
    self:LinkFirstPageFocus()
end

function LewdDialog:ReCreateTitsSelectDisguise()
	if self.tits_ui_disguise_widget ~= nil then
	    self.tits_ui_disguise_widget:Kill()
	end
	
    local widget, spinner
    if CanChangeBoobsSize(self.nude_build_disguise) then
        widget, spinner = CreateTextSpinner("Tits", { 
        { text = "None", data = "none" }, 
        { text = "Flat", data = "flat" }, 
        { text = "Small", data = "small" },
        { text = "Medium", data = "medium" },	
        { text = "Large", data = "large" } })
    else
        widget, spinner = CreateTextSpinner("Tits", { 
        { text = "Locked", data = "none" } }) 
    end
    
    self.tits_ui_disguise_widget = self.root:AddChild(widget)
    self.tits_ui_disguise = spinner
    self.tits_ui_disguise_widget:SetPosition(-75, -100)
	self.tits_ui_disguise.OnChanged = function( _, data )
	    self.tits_disguise = data
		self:ApplyDisguise(self.selected_disguise)
	end
	self.tits_ui_disguise:SetSelectedIndex(NameToIndex[self.tits_disguise])
    if TheInput:ControllerAttached() and self.nude_custom_disguise and self.done2_btn then
        self.nude_custom_disguise:SetFocusChangeDir(MOVE_DOWN, self.tits_ui_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_UP, self.nude_custom_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_DOWN, self.done2_btn)
        self.done2_btn:SetFocusChangeDir(MOVE_UP, self.tits_ui_disguise)
    end
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
	
	if prefab == "" or prefab == nil then
		if self.puppet and self.puppet.animstate then
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
		end
		self:SetNude()
		
		if self.dick_text then self.dick_text:Hide() end
		if self.dick_ui_disguise_widget then self.dick_ui_disguise_widget:Hide() end
		if self.nude_text then self.nude_text:Hide() end
	    if self.nude_custom_disguise_widget then self.nude_custom_disguise_widget:Hide() end
		if self.tits_text then self.tits_text:Hide() end
		if self.tits_ui_disguise_widget then self.tits_ui_disguise_widget:Hide() end
		if self.tint_text then self.tint_text:Hide() end
		if self.tint_r_dis_widget then self.tint_r_dis_widget:Hide() end
        if self.tint_g_dis_widget then self.tint_g_dis_widget:Hide() end
        if self.tint_b_dis_widget then self.tint_b_dis_widget:Hide() end
        if self.tint_r_field_dis then self.tint_r_field_dis:Hide() end
        if self.tint_g_field_dis then self.tint_g_field_dis:Hide() end
        if self.tint_b_field_dis then self.tint_b_field_dis:Hide() end
        if self.tint_r_field_dis and self.tint_r_field_dis.done_btn then self.tint_r_field_dis.done_btn:Hide() end
        if self.tint_g_field_dis and self.tint_g_field_dis.done_btn then self.tint_g_field_dis.done_btn:Hide() end
		if self.tint_b_field_dis and self.tint_b_field_dis.done_btn then self.tint_b_field_dis.done_btn:Hide() end
return
end
if self.dick_text then self.dick_text:Show() end
if self.dick_ui_disguise_widget then self.dick_ui_disguise_widget:Show() end
if self.nude_text then self.nude_text:Show() end
if self.nude_custom_disguise_widget then self.nude_custom_disguise_widget:Show() end
if self.tits_text then self.tits_text:Show() end
if self.tits_ui_disguise_widget then self.tits_ui_disguise_widget:Show() end
if self.tint_text then self.tint_text:Show() end
if self.tint_r_dis_widget then self.tint_r_dis_widget:Show() end
if self.tint_g_dis_widget then self.tint_g_dis_widget:Show() end
if self.tint_b_dis_widget then self.tint_b_dis_widget:Show() end
if self.tint_r_field_dis and self.tint_r_field_dis.editmode then self.tint_r_field_dis:Show() end
if self.tint_g_field_dis and self.tint_g_field_dis.editmode then self.tint_g_field_dis:Show() end
if self.tint_b_field_dis and self.tint_b_field_dis.editmode then self.tint_b_field_dis:Show() end
if self.tint_r_field_dis and self.tint_r_field_dis.done_btn then self.tint_r_field_dis.done_btn:Show() end
if self.tint_g_field_dis and self.tint_g_field_dis.done_btn then self.tint_g_field_dis.done_btn:Show() end
if self.tint_b_field_dis and self.tint_b_field_dis.done_btn then self.tint_b_field_dis.done_btn:Show() end
local build = self.nude_build_disguise
if build == nil or build == "" then
build = prefab
end
local titssize = self.tits_disguise
local titsbuild = GetTitsBySize(prefab, titssize)	
if titsbuild == nil then
titsbuild = build
end
if self.puppet and self.puppet.animstate then
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
if self.tits_text then self.tits_text:Hide() end
if self.dick_text then self.dick_text:Hide() end
if self.nude_text then self.nude_text:Hide() end
if self.nude_custom_widget then self.nude_custom_widget:Hide() end
if self.dick_ui_widget then self.dick_ui_widget:Hide() end
if self.done_btn then self.done_btn:Hide() end
if self.tits_ui_widget then self.tits_ui_widget:Hide() end
CharsList = GetActiveCharacterList()
local button = {{text = "Done", cb = function()
self:Done()
end}}
local tintnumbers = {}
for i = 0, 255, 1 do
table.insert(tintnumbers, {text = i, data = i / 255})
end
local tintY = 35
local wr, sr = CreateTextSpinner("Tint", tintnumbers)
self.tint_r_dis_widget = self.root:AddChild(wr)
self.tint_r_dis = sr
self.tint_r_dis_widget:SetPosition(325, tintY)
self.tint_r_dis:SetSelectedIndex(256)
self.tint_r_dis.OnChanged = function( _, data )
self.tint_dis.r = data
self:ApplyDisguise(self.selected_disguise, true)
end
self.tint_r_field_dis = self:CreateTextBox(325, tintY, self.tint_r_dis)
local wg, sg = CreateTextSpinner("Tint", tintnumbers)
self.tint_g_dis_widget = self.root:AddChild(wg)
self.tint_g_dis = sg
self.tint_g_dis_widget:SetPosition(325, tintY-30)
self.tint_g_dis:SetSelectedIndex(256)
self.tint_g_dis.OnChanged = function( _, data )
self.tint_dis.g = data
self:ApplyDisguise(self.selected_disguise, true)
end
self.tint_g_field_dis = self:CreateTextBox(325, tintY-30, self.tint_g_dis)
local wb, sb = CreateTextSpinner("Tint", tintnumbers)
self.tint_b_dis_widget = self.root:AddChild(wb)
self.tint_b_dis = sb
self.tint_b_dis_widget:SetPosition(325, tintY-60)
self.tint_b_dis :SetSelectedIndex(256)
self.tint_b_dis .OnChanged = function( _, data )
self.tint_dis.b = data
self:ApplyDisguise(self.selected_disguise, true)
end
self.tint_b_field_dis = self:CreateTextBox(325, tintY-60, self.tint_b_dis)
self.done2_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
self.done2_btn:SetPosition(150, -175)
self:ReCreateTitsSelectDisguise()
self.disguise_text = self.root:AddChild(Text(TITLEFONT, 34, "Disguise as"))
self.disguise_text:SetPosition(-75, 100)
local SpinerData = GetPossibleDisguiseCandiates()
local wd, sd = CreateTextSpinner("Dick", {
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
})
self.dick_ui_disguise_widget = self.root:AddChild(wd)
self.dick_ui_disguise = sd
self.dick_ui_disguise_widget:SetPosition(325, -100)
self.dick_ui_disguise.OnChanged = function( _, data )
self.dick_disguise = data
self:ApplyDisguise(self.selected_disguise)
end
local wn, sn = CreateTextSpinner("Nude skin", self.nudebuildoptions)
self.nude_custom_disguise_widget = self.root:AddChild(wn)
self.nude_custom_disguise = sn
self.nude_custom_disguise_widget:SetPosition(-75, 0)	
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
    local ws, ss = CreateTextSpinner("Disguise", SpinerData)
    self.disguise_select_widget = self.root:AddChild(ws)
    self.disguise_select = ss
    self.disguise_select_widget:SetPosition(-75, 65)	
    
    self.disguise_select.OnChanged = function( _, data )	
        self.selected_disguise = data
        if GetGenderStrings(self.selected_disguise) ~= "FEMALE" then	
            self.dick_disguise = GetDefaultDick(self.selected_disguise)
            if self.dick_ui_disguise then self.dick_ui_disguise:SetSelectedIndex(NameToIndex[self.dick_disguise]) end
        else
            self.dick_disguise = ""
            if self.dick_ui_disguise then self.dick_ui_disguise:SetSelectedIndex(NameToIndex[self.dick_disguise]) end
        end
        if self.selected_disguise == "" then
            self.nude_build_disguise = GetNudeBuild(ThePlayer.prefab)
        else
            self.nude_build_disguise = GetNudeBuild(self.selected_disguise)
        end
        if self.nude_custom_disguise then self.nude_custom_disguise:SetSelectedIndex(NameToIndex[self.nude_build_disguise]) end
        if self.nude_build_disguise == "male_nude" then
            self.tits_disguise = "none"
        end
        if CanChangeBoobsSize(self.nude_build_disguise) == false then
            self.tits_disguise = "none"
        end
        if self.nude_custom_disguise_widget and self.nude_build_disguise == "wendy_nude" then
            self.tits_disguise = GetDefaultTitsSize(self.selected_disguise)
        end
        self:ReCreateTitsSelectDisguise()		
        self:ApplyDisguise(data)
        
        -- === THIS IS THE LIVE SPINNER TOGGLE LOOP (Inside the OnChanged block) ===
        if TheInput:ControllerAttached() and self.disguise_select and self.done2_btn then
            if data == "" or data == nil then
                self.disguise_select:SetFocusChangeDir(MOVE_DOWN, self.done2_btn)
                self.done2_btn:SetFocusChangeDir(MOVE_UP, self.disguise_select)
            else
                self.disguise_select:SetFocusChangeDir(MOVE_DOWN, self.nude_custom_disguise)
                self.nude_custom_disguise:SetFocusChangeDir(MOVE_UP, self.disguise_select)
            end
        end
    end -- This explicitly closes the disguise_select.OnChanged function block

    -- These are your original texture hides running at the end of the function layout
    self:ApplyDisguise(self.selected_disguise)
    self.tint_r:Hide()
    self.tint_g:Hide()
    self.tint_b:Hide()
    self.tint_text:Hide()
    self.tint_r_field.done_btn:Hide()
    self.tint_g_field.done_btn:Hide()
    self.tint_b_field.done_btn:Hide()
    
    self:LinkSecondPageFocus()
    
    -- === THIS IS THE INITIALIZATION END SEQUENCE (At the absolute tail end of StartDisguise) ===
    if TheInput:ControllerAttached() and self.disguise_select and self.done2_btn then
        local current_disguise = self.selected_disguise or ""
        if current_disguise == "" then
            self.disguise_select:SetFocusChangeDir(MOVE_DOWN, self.done2_btn)
            self.done2_btn:SetFocusChangeDir(MOVE_UP, self.disguise_select)
        else
            self.disguise_select:SetFocusChangeDir(MOVE_DOWN, self.nude_custom_disguise)
        end
        
        -- Keeps the cursor active and highlighted right when the page turns
        self.disguise_select:SetFocus()
    end
end
function LewdDialog:CreateTextBox(x, y, spiner)
local textentry_width = 180
local textentry_height = 30
local textentry = self.root:AddChild(TEMPLATES.StandardSingleLineTextEntry(nil, textentry_width, textentry_height, NEWFONT, 18, ""))
textentry.editmode = false
textentry:SetPosition(x, y)
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

    textentry.focusable = false
    textentry.done_btn.focusable = false

return textentry
end
function LewdDialog:StartEdit()
self.title:SetString("Character edit")
if self.text then self.text:Kill() end
if self.intro_menu then self.intro_menu:Kill() end
self.puppet:Show()
self.tint = {r = 1, g = 1, b = 1}
self.tits_text = self.root:AddChild(Text(TITLEFONT, 34, "Tits Size"))
self.tits_text:SetPosition(-75, -65)
self.dick_text = self.root:AddChild(Text(TITLEFONT, 34, "Dick"))
self.dick_text:SetPosition(325, -65)
self.nude_text = self.root:AddChild(Text(TITLEFONT, 34, "Nude skin"))
self.nude_text:SetPosition(-75, 35)
local w, s = CreateTextSpinner("Nude skin", self.nudebuildoptions)
self.nude_custom_widget = self.root:AddChild(w)
self.nude_custom = s
self.nude_custom_widget:SetPosition(-75, 0)
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
local wd, sd = CreateTextSpinner("Dick", {
{ text = "None", data = "none" },
{ text = "White", data = "white_dick" },
{ text = "Brown", data = "walter_dick" },
{ text = "Gray", data = "warly_dick" },
{ text = "Robo", data = "wx78_dick" },
{ text = "Spider", data = "webber_dick" },
{ text = "Spider White", data = "webber_dick_white" },
{ text = "Spider Brown", data = "webber_dick_brown" },
{ text = "Plant", data = "wormla_dick" },
{ text = "Red", data = "wortox_dick" }
})
self.dick_ui_widget = self.root:AddChild(wd)
self.dick_ui = sd
self.dick_ui_widget:SetPosition(325, -100)
self.dick_ui.OnChanged = function( _, data )
self.dick = data
self:SetNude()
end
self.dick_ui:SetSelectedIndex(NameToIndex[self.dick])
local tintnumbers = {}
for i = 0, 255, 1 do
table.insert(tintnumbers, {text = i, data = i / 255})
end
local tintY = 35
local wr, sr = CreateTextSpinner("Tint", tintnumbers)
self.tint_r_widget = self.root:AddChild(wr)
self.tint_r = sr
self.tint_r_widget:SetPosition(325, tintY)
self.tint_r:SetSelectedIndex(256)
self.tint_r.OnChanged = function( _, data)
self.tint.r = data
self:SetNude(true)
end
self.tint_r_field = self:CreateTextBox(325, tintY, self.tint_r)
local wg, sg = CreateTextSpinner("Tint", tintnumbers)
self.tint_g_widget = self.root:AddChild(wg)
self.tint_g = sg
self.tint_g_widget:SetPosition(325, tintY-30)
self.tint_g:SetSelectedIndex(256)
self.tint_g.OnChanged = function( _, data )
self.tint.g = data
self:SetNude(true)
end
self.tint_g_field = self:CreateTextBox(325, tintY-30, self.tint_g)
local wb, sb = CreateTextSpinner("Tint", tintnumbers)
self.tint_b_widget = self.root:AddChild(wb)
self.tint_b = sb
self.tint_b_widget:SetPosition(325, tintY-60)
self.tint_b:SetSelectedIndex(256)
self.tint_b.OnChanged = function( _, data )
self.tint.b = data
self:SetNude(true)
end
self.tint_b_field = self:CreateTextBox(325, tintY-60, self.tint_b)
self.tint_text = self.root:AddChild(Text(TITLEFONT, 34, "Custom Color"))
self.tint_text:SetPosition(325, tintY+35)
self:SetNude()
local edit_buttons = {
{ text = "Next Panel", cb = function() self:StartDisguise() end }
}
self.done_btn = self.root:AddChild(Menu(edit_buttons, 0, false, "carny_xlong", nil, 30))
self.done_btn:SetPosition(150, -175)
self:LinkFirstPageFocus()
if TheInput:ControllerAttached() and self.nude_custom then
self.nude_custom:SetFocus()
end
end
function LewdDialog:LinkFirstPageFocus()
    if not TheInput:ControllerAttached() then return end
    
    -- Left Column Grid Mapping
    if self.nude_custom and self.tits_ui and self.done_btn then
        self.nude_custom:SetFocusChangeDir(MOVE_DOWN, self.tits_ui)
        self.tits_ui:SetFocusChangeDir(MOVE_UP, self.nude_custom)
        self.tits_ui:SetFocusChangeDir(MOVE_DOWN, self.done_btn)
        self.done_btn:SetFocusChangeDir(MOVE_UP, self.tits_ui)
        
        -- Safe bounded horizontal exits
        self.nude_custom:SetFocusChangeDir(MOVE_LEFT, self.nude_custom)
        self.tits_ui:SetFocusChangeDir(MOVE_LEFT, self.tits_ui)
        self.done_btn:SetFocusChangeDir(MOVE_LEFT, self.done_btn)
        
        if self.tint_r then self.nude_custom:SetFocusChangeDir(MOVE_RIGHT, self.tint_r) end
        if self.dick_ui then self.tits_ui:SetFocusChangeDir(MOVE_RIGHT, self.dick_ui) end
        if self.done_btn then self.done_btn:SetFocusChangeDir(MOVE_RIGHT, self.done_btn) end
    end
    
    -- Right Column Grid Mapping
    if self.tint_r and self.tint_g and self.tint_b and self.dick_ui then
        self.tint_r:SetFocusChangeDir(MOVE_DOWN, self.tint_g)
        self.tint_g:SetFocusChangeDir(MOVE_UP, self.tint_r)
        self.tint_g:SetFocusChangeDir(MOVE_DOWN, self.tint_b)
        self.tint_b:SetFocusChangeDir(MOVE_UP, self.tint_g)
        self.tint_b:SetFocusChangeDir(MOVE_DOWN, self.dick_ui)
        self.dick_ui:SetFocusChangeDir(MOVE_UP, self.tint_b)
        
        if self.done_btn then self.dick_ui:SetFocusChangeDir(MOVE_DOWN, self.done_btn) end
        
        -- Force rightward inputs to stay in the column
        self.tint_r:SetFocusChangeDir(MOVE_RIGHT, self.tint_r)
        self.tint_g:SetFocusChangeDir(MOVE_RIGHT, self.tint_g)
        self.tint_b:SetFocusChangeDir(MOVE_RIGHT, self.tint_b)
        self.dick_ui:SetFocusChangeDir(MOVE_RIGHT, self.dick_ui)
        
        if self.nude_custom then self.tint_r:SetFocusChangeDir(MOVE_LEFT, self.nude_custom) end
        if self.nude_custom then self.tint_g:SetFocusChangeDir(MOVE_LEFT, self.nude_custom) end
        if self.nude_custom then self.tint_b:SetFocusChangeDir(MOVE_LEFT, self.nude_custom) end
        if self.tits_ui then self.dick_ui:SetFocusChangeDir(MOVE_LEFT, self.tits_ui) end
    end
end
function LewdDialog:LinkSecondPageFocus()
    if not TheInput:ControllerAttached() then return end
    
    -- Left Column Grid Mapping (Always exists on page 2)
    if self.disguise_select and self.nude_custom_disguise and self.tits_ui_disguise and self.done2_btn then
        self.disguise_select:SetFocusChangeDir(MOVE_DOWN, self.nude_custom_disguise)
        self.nude_custom_disguise:SetFocusChangeDir(MOVE_UP, self.disguise_select)
        self.nude_custom_disguise:SetFocusChangeDir(MOVE_DOWN, self.tits_ui_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_UP, self.nude_custom_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_DOWN, self.done2_btn)
        self.done2_btn:SetFocusChangeDir(MOVE_UP, self.tits_ui_disguise)
        
        -- Safe bounded left exits
        self.disguise_select:SetFocusChangeDir(MOVE_LEFT, self.disguise_select)
        self.nude_custom_disguise:SetFocusChangeDir(MOVE_LEFT, self.nude_custom_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_LEFT, self.tits_ui_disguise)
        self.done2_btn:SetFocusChangeDir(MOVE_LEFT, self.done2_btn)
        
        -- Default: if right side doesn't exist, dead-end rightward inputs
        self.disguise_select:SetFocusChangeDir(MOVE_RIGHT, self.disguise_select)
        self.nude_custom_disguise:SetFocusChangeDir(MOVE_RIGHT, self.nude_custom_disguise)
        self.tits_ui_disguise:SetFocusChangeDir(MOVE_RIGHT, self.tits_ui_disguise)
        self.done2_btn:SetFocusChangeDir(MOVE_RIGHT, self.done2_btn)
    end
    
    -- Right Column Grid Mapping (ONLY links if the color widgets are active and visible)
    if self.tint_r_dis and self.tint_g_dis and self.tint_b_dis and self.dick_ui_disguise and self.tint_r_dis:IsVisible() then
        self.tint_r_dis:SetFocusChangeDir(MOVE_DOWN, self.tint_g_dis)
        self.tint_g_dis:SetFocusChangeDir(MOVE_UP, self.tint_r_dis)
        self.tint_g_dis:SetFocusChangeDir(MOVE_DOWN, self.tint_b_dis)
        self.tint_b_dis:SetFocusChangeDir(MOVE_UP, self.tint_g_dis)
        self.tint_b_dis:SetFocusChangeDir(MOVE_DOWN, self.dick_ui_disguise)
        self.dick_ui_disguise:SetFocusChangeDir(MOVE_UP, self.tint_b_dis)
        
        if self.done2_btn then self.dick_ui_disguise:SetFocusChangeDir(MOVE_DOWN, self.done2_btn) end
        
        -- Safe bounded right exits
        self.tint_r_dis:SetFocusChangeDir(MOVE_RIGHT, self.tint_r_dis)
        self.tint_g_dis:SetFocusChangeDir(MOVE_RIGHT, self.tint_g_dis)
        self.tint_b_dis:SetFocusChangeDir(MOVE_RIGHT, self.tint_b_dis)
        self.dick_ui_disguise:SetFocusChangeDir(MOVE_RIGHT, self.dick_ui_disguise)
        
        -- Bridge the cross-column navigation safely
        if self.disguise_select then self.disguise_select:SetFocusChangeDir(MOVE_RIGHT, self.tint_r_dis) end
        if self.nude_custom_disguise then self.nude_custom_disguise:SetFocusChangeDir(MOVE_RIGHT, self.tint_g_dis) end
        if self.tits_ui_disguise then self.tits_ui_disguise:SetFocusChangeDir(MOVE_RIGHT, self.tint_b_dis) end
        
        if self.disguise_select then self.tint_r_dis:SetFocusChangeDir(MOVE_LEFT, self.disguise_select) end
        if self.nude_custom_disguise then self.tint_g_dis:SetFocusChangeDir(MOVE_LEFT, self.nude_custom_disguise) end
        if self.tits_ui_disguise then self.tint_b_dis:SetFocusChangeDir(MOVE_LEFT, self.tits_ui_disguise) end
        if self.tits_ui_disguise then self.dick_ui_disguise:SetFocusChangeDir(MOVE_LEFT, self.tits_ui_disguise) end
    end
    
    if self.disguise_select then
        self.disguise_select:SetFocus()
    end
end
function LewdDialog:DoNext()
local d = DialogNum
if d == 1 then
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
if self.nude_build == "" then return false end
local build = GetTitsBySize(ThePlayer.prefab, tits)	
if build == nil then build = self.nude_build end
if puppet and puppet.animstate then puppet.animstate:OverrideSymbol("torso", build, "torso") end
end
function LewdDialog:SetSymbolTint(symbol)
local tint = self.tint
if self.nude_build == "" then tint = {r = 1, g = 1, b = 1} end
if self.puppet and self.puppet.animstate then self.puppet.animstate:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1) end
end
function LewdDialog:SetSymbolTintDis(symbol)
local tint = self.tint_dis or {r = 1, g = 1, b = 1}
if self.selected_disguise == "" or self.selected_disguise == nil then
self:SetSymbolTint(symbol)
return
end
if self.puppet and self.puppet.animstate then self.puppet.animstate:SetSymbolMultColour(symbol, tint.r, tint.g, tint.b, 1) end
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
self:SetSymbolTintDis("dick")
if skipanimchange == nil and puppet and puppet.animstate then
if self.dick == "none" then
puppet.animstate:PlayAnimation("fap_loop_girl_new_new", true)
self.puppet.animstate:ClearOverrideSymbol("dick")
else
puppet.animstate:OverrideSymbol("dick", self.dick, "dick")
puppet.animstate:PlayAnimation("fap_loop_new_new", true)
end
end
if self.nude_build == "" then
if puppet then puppet:SetSkins(ThePlayer.prefab, self.base_skin, {}, true) end
if self.tint_r_widget then self.tint_r_widget:Hide() end
if self.tint_g_widget then self.tint_g_widget:Hide() end
if self.tint_b_widget then self.tint_b_widget:Hide() end
if self.tint_text then self.tint_text:Hide() end
if self.tint_r_field then self.tint_r_field:Hide() end
if self.tint_g_field then self.tint_g_field:Hide() end
if self.tint_b_field then self.tint_b_field:Hide() end
if self.tint_r_field and self.tint_r_field.done_btn then self.tint_r_field.done_btn:Hide() end
if self.tint_g_field and self.tint_g_field.done_btn then self.tint_g_field.done_btn:Hide() end
if self.tint_b_field and self.tint_b_field.done_btn then self.tint_b_field.done_btn:Hide() end
return false
end
if self.tint_dis == nil then
if self.tint_r_widget then self.tint_r_widget:Show() end
if self.tint_g_widget then self.tint_g_widget:Show() end
if self.tint_b_widget then self.tint_b_widget:Show() end
if self.tint_r_field and self.tint_r_field.editmode then self.tint_r_field:Show() end
if self.tint_g_field and self.tint_g_field.editmode then self.tint_g_field:Show() end
if self.tint_b_field and self.tint_b_field.editmode then self.tint_b_field:Show() end
if self.tint_r_field and self.tint_r_field.done_btn then self.tint_r_field.done_btn:Show() end
if self.tint_g_field and self.tint_g_field.done_btn then self.tint_g_field.done_btn:Show() end
if self.tint_b_field and self.tint_b_field.done_btn then self.tint_b_field.done_btn:Show() end
if self.tint_text then self.tint_text:Show() end
end
self:SetTits(self.tits)
if puppet and puppet.animstate then
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
end
function LewdDialog:Done()
TheFrontEnd:FadeBack(nil, nil, function()
local t_dis = self.tint_dis or {r = 1, g = 1, b = 1}
SendModRPCToServer(MOD_RPC["LEWD"]["SPAWNED"], ThePlayer, self.tits, self.dick, self.nude_build, self.selected_disguise, self.dick_disguise, self.nude_build_disguise, self.tits_disguise,
self.tint.r,
self.tint.g,
self.tint.b,
t_dis.r,
t_dis.g,
t_dis.b)
TheInput:CacheController()
self.active = false
TheFrontEnd:PopScreen(self)
end)	
end
function LewdDialog:OnControl(control, down)
    if LewdDialog._base.OnControl(self, control, down) then
        return true
    end

    if down and (control == CONTROL_ACCEPT or control == CONTROL_PRIMARY or control == CONTROL_ACTION) then
        local active_menus = { self.intro_menu, self.done_btn, self.done2_btn }
        for _, menu_container in ipairs(active_menus) do
            if menu_container and menu_container.focus and menu_container.items then
                for _, item in ipairs(menu_container.items) do
                    if item.focus then
                        if item.onclick then item.onclick() return true end
                        if item.cb then item.cb() return true end
                    end
                end
            end
        end
    end

    local dynamic_spinners = {
        self.nude_custom, self.tits_ui, self.dick_ui, self.tint_r, self.tint_g, self.tint_b,
        self.disguise_select, self.nude_custom_disguise, self.tits_ui_disguise, self.dick_ui_disguise,
        self.tint_r_dis, self.tint_g_dis, self.tint_b_dis
    }
    for _, spin in ipairs(dynamic_spinners) do
        if spin and spin.focus and spin.OnControl then
            if spin:OnControl(control, down) then return true end
        end
    end

    return false
end
return LewdDialog