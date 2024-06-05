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

local NextScreen = require "screens/lewddialog"




-- scheduler:ExecuteInTime(0.1,function() print(TheFrontEnd:GetActiveScreen()) end, "")





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
    self.bg = self.root:AddChild(TEMPLATES.PlainBackground())

    self.dialog = self.root:AddChild(TEMPLATES.RectangleWindow(dialog_size_x, dialog_size_y))
    self.dialog:SetPosition(0, 10)
    self.panel_root = self.dialog:InsertWidget(Widget("panel_root"))
    self.panel_root:SetPosition(0, -41)
    self.title = self.root:AddChild(Text(TITLEFONT, 34, ""))
	self.title:SetPosition(0, 295)
    self.title:SetString("WARNING")

    self.text = self.root:AddChild(Text(TITLEFONT, 34, ""))
	self.text:SetPosition(0, 100)
    --self.text:SetString("This mod made for fun, and not want to hurt anyones feelings.\n If you continue you automatic apply you are adult. All characters in this mod are adult.\n Please do not upload any content (files, videos, screenshots) from mod anywhere,\n please author is human too, and when you steal content you make author starving.")	
    self.text:SetString("This mode was made for fun, and is not intended to upset anyone.\n By continuing on to the mod you consent that you are an adult.\n Please refrain from uploading mod to other sites without my permission.\n Mod right now is opensource, but you still can donate to author if you like the mod\n visit https://www.patreon.com/user?u=38042354\n All characters depicted in this mod are adults.")


    local button = {{text = "Continue", cb = function() 
	     TheFrontEnd:FadeToScreen(TheFrontEnd:GetActiveScreen(), function() return NextScreen() end, nil, "swipe") 
	end}}
	
    self.continue_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	--self.continue_btn:SetScale(.75,.75,.75)
	self.continue_btn:SetPosition(0, -100)
	
    local button = {{text = "Quit", cb = function() 
	     DoRestart(true)
	end}}
	
    self.quit_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.quit_btn:SetPosition(0, -175)

	
    self.reset_title = self.root:AddChild(Text(TITLEFONT, 30))
    self.reset_title:SetPosition(140,-330)
end)

return LewdStart
