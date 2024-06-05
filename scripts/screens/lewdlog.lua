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
local ScrollableList = require "widgets/scrollablelist"
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

local controls_ui = {
    action_label_width = 375,
    action_btn_width = 250,
    action_height = 48,
}

local total_anims = 0
local total_unlocked = 0

local LewdLog = Class(Screen, function(self)
    Screen._ctor(self, "LewdLog")
	
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
	
    self.title = self.root:AddChild(Text(TITLEFONT, 45, ""))
	self.title:SetPosition(0, 280)
    self.title:SetString("Sex memory albume")
	
    self.virgin = self.root:AddChild(Text(TITLEFONT, 30, ""))
	self.virgin:SetPosition(295, -230)
    self.virgin:SetString("Lost virgitny on this server with:\n"..ThePlayer.firstfuckername_client:value())
	
    self.proctprogress = self.root:AddChild(Text(TITLEFONT, 45, ""))
	self.proctprogress:SetPosition(337, 100)
    self.proctprogress:SetString("0%")
	
    self.proctprogress2 = self.root:AddChild(Text(TITLEFONT, 35, ""))
	self.proctprogress2:SetPosition(360, 5)
    self.proctprogress2:SetString("0\nof\n0")

	self.progressbar = self.root:AddChild(UIAnim())
	self.progressbar:SetPosition(330, 0)
	self.progressbar:SetScale(1)
	self.progressbar:SetRotation(-90)
    self.progressbar:GetAnimState():SetBank("player_progressbar_small")
	self.progressbar:GetAnimState():SetBuild("player_progressbar_small")
    self.progressbar:GetAnimState():PlayAnimation("fill_progress", false)
	self.progressbar:GetAnimState():SetPercent("fill_progress", 0)

    --self.root:SetPosition(160,0)

	self.controls_horizontal_line = self.root:AddChild(Image("images/global_redux.xml", "item_divider.tex"))
    self.controls_horizontal_line:SetScale(.9)
    self.controls_horizontal_line:SetPosition(-30, 175)
	
    local button = {{text = "Close", cb = function() 
         TheInput:CacheController()
	     self.active = false 
	     TheFrontEnd:PopScreen(self)
	end}}
	
    self.quit_btn = self.root:AddChild(Menu(button, 0, false, "carny_xlong", nil, 30))
	self.quit_btn:SetPosition(0, -220)
	
	local button_x = -40 -- x coord of the left edge
    local button_width = controls_ui.action_btn_width
    local button_height = controls_ui.action_height
    local spacing = 15
	
    local function BuildControlGroup(index, txt, arrx)

            local group = Widget("control"..index)
            group.bg = group:AddChild(TEMPLATES.ListItemBackground(700, button_height))
            group.bg:SetPosition(225,0)
			group.bg:SetClickable(true)
	        function group.bg:OnControl(control, down)
		        if control == CONTROL_ACCEPT then
			        if down then
				        self.down = true
			        elseif self.down then
			            self.down = false
						self.active = false
						local NextScreen = require "screens/lewdwatch"
			            local openscreen = NextScreen(arrx)
	                    TheFrontEnd:PushScreen(openscreen)
			        end
		        end
	        end			
	
            group:SetScale(1,1,0.75)

            local x = button_x

            group.label = group:AddChild(Text(CHATFONT, 28))
            group.label:SetString(txt)
            group.label:SetHAlign(ANCHOR_LEFT)
            group.label:SetColour(UICOLOURS.GOLD_UNIMPORTANT)
            group.label:SetRegionSize(controls_ui.action_label_width, 50)
            x = x + controls_ui.action_label_width/2
            group.label:SetPosition(x,0)
            x = x + controls_ui.action_label_width/2 + spacing

            x = x + button_width/2
            group.changed_image = group:AddChild(Image("images/global_redux.xml", "wardrobe_spinner_bg.tex"))
            group.changed_image:SetTint(1,1,1,0.3)
            group.changed_image:ScaleToSize(button_width, button_height)
            group.changed_image:SetPosition(x,0)
            group.changed_image:Hide()

            group.binding_btn = group:AddChild(ImageButton("images/global_redux.xml", "blank.tex", "spinner_focus.tex"))
            group.binding_btn:ForceImageSize(button_width, button_height)
            group.binding_btn:SetTextColour(UICOLOURS.GOLD_CLICKABLE)
            group.binding_btn:SetTextFocusColour(UICOLOURS.GOLD_FOCUS)
            group.binding_btn:SetFont(CHATFONT)
            group.binding_btn:SetTextSize(30)
            group.binding_btn:SetPosition(x,0)
            group.binding_btn.idx = index
            group.binding_btn:SetClickable(false)
            x = x + button_width/2 + spacing
			
			local howmanyanims = 0
			local howmanyunlocked = 0
			local class = LEWD_CATALOG[arrx]["group"]
			
			for x = 1, #LEWD_CATALOG, 1 do 
			    if LEWD_CATALOG[x]["group"] == class then
				    howmanyanims = howmanyanims+1
					if Profile:LewdAnimUnlocked(LEWD_CATALOG[x]["anim"]) then
					    howmanyunlocked = howmanyunlocked+1
					end
				end
			end

            group.binding_btn:SetDisabledFont(CHATFONT)
            group.binding_btn:SetText(howmanyunlocked.."/"..howmanyanims)
            group.focus_forward = group.binding_btn
			
			total_anims = total_anims+howmanyanims
			total_unlocked = total_unlocked+howmanyunlocked

            return group
    end
	

    self.kb_controlwidgets = {}
	
	local last_added = ""
	local index_ = 0

    for x = 1, #LEWD_CATALOG, 1 do   
	    local class = LEWD_CATALOG[x]["group"]
		if last_added ~= class then
		    last_added = class
			index_ = index_+1
            local group = BuildControlGroup(index_, class, x)
			--group:SetPosition(50,0)
		    table.insert(self.kb_controlwidgets, group)
		end
    end
	
	local total_proc = (total_unlocked/total_anims)*100
	self.proctprogress:SetString(math.floor(total_proc).."%")
	self.proctprogress2:SetString(total_unlocked.."\n".."of\n"..total_anims)
	self.progressbar:GetAnimState():SetPercent("fill_progress", total_proc/100)
	
	
	local align_to_scroll = self.root:AddChild(Widget(""))
    align_to_scroll:SetPosition(-160, 200) -- hand-tuned amount that aligns with scrollablelist
	
    local x = button_x
    x = x + controls_ui.action_label_width/2
	self.actions_header = self.root:AddChild(Text(HEADERFONT, 30, "Type"))
	self.actions_header:SetColour(UICOLOURS.GOLD_UNIMPORTANT)
	self.actions_header:SetPosition(-280, 205) -- move a bit towards text
    x = x + controls_ui.action_label_width/2

    self.controls_vertical_line = align_to_scroll:AddChild(Image("images/global_redux.xml", "item_divider.tex"))
    self.controls_vertical_line:SetScale(.7, .43)
    self.controls_vertical_line:SetRotation(90)
    self.controls_vertical_line:SetPosition(x-120, -200)
    self.controls_vertical_line:SetTint(1,1,1,.1)
    x = x + spacing

    x = x + button_width/2
    self.controls_header = self.root:AddChild(Text(HEADERFONT, 30))
    self.controls_header:SetString("Progress")
    self.controls_header:SetColour(UICOLOURS.GOLD_UNIMPORTANT)
    self.controls_header:SetPosition(140, 205)
    x = x + button_width/2 + spacing

    local function CreateScrollableList(items)
        local width = controls_ui.action_label_width + spacing + controls_ui.action_btn_width + 550
        return ScrollableList(items, width/2, 330, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "GOLD")
    end
	self.kb_controllist = self.root:AddChild(CreateScrollableList(self.kb_controlwidgets))

    self.root.focus_forward = function()
        return self.active_list
    end
end)

return LewdLog
