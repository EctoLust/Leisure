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

local LewdStart = Class(Screen, function(self)
    Screen._ctor(self, "LewdStart")
	
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,1) 
	
	self.root = self:AddChild(TEMPLATES.ScreenRoot("ROOT"))

	self.cd = self.root:AddChild(UIAnim())
	self.cd:SetPosition(-350, 300)
	self.cd:SetScale(2)
    self.cd:GetAnimState():SetBank("cdman")
	self.cd:GetAnimState():SetBuild("cdman")
    self.cd:GetAnimState():PlayAnimation("CD", true)
	
    self.title = self.root:AddChild(Text(TITLEFONT, 50, ""))
	self.title:SetPosition(0, 295)
    self.title:SetString("WHOOPS, you have to put cd intro your computer!")
	TheFrontEnd:GetSound():PlaySound("dontstarve_DLC001/music/music_work_summer", "mbg")
	TheFrontEnd:GetSound():SetParameter("mbg", "intensity", 5)
end)

return LewdStart
