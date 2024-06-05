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

local SexPoseScreen = Class(Screen, function(self)
    Screen._ctor(self, "SexPoseScreen")

    TheInput:ClearCachedController()

    self.active = true

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
    --create the menu itself
    local button_w = 160
    local button_h = 50
	
    self.title = self.proot:AddChild(Text(BUTTONFONT, 50))
    self.title:SetPosition(0, 170, 0)
    self.title:SetString("What pose you want?")
    self.title:SetColour(1,1,1,1)
	
	local fucker_name = ThePlayer.fuckerprefab_client:value()
	local fucker_group = GetPosesGroup(fucker_name)
	
	if fucker_name == "" or fucker_group == "" then
        TheInput:CacheController()
	    self.active = false
        TheFrontEnd:PopScreen(self)
    end	

    local buttons = {}
	
	if fucker_group == "player" or fucker_group == "hermitcrab" then
        table.insert(buttons, {text="Oral", cb=function() self:DoRPC("oral") end })
	    table.insert(buttons, {text="Ride", cb=function() self:DoRPC("ride") end })
	    table.insert(buttons, {text="Flipfuck", cb=function() self:DoRPC("flipfuck") end })
	    table.insert(buttons, {text="On the knees", cb=function() self:DoRPC("onkness") end })	
		table.insert(buttons, {text="Doggy-Style", cb=function() self:DoRPC("doggy") end })
	    table.insert(buttons, {text="Swap", cb=function() self:DoRPC("swap") end })
	else
		if POSES_BY_GROUP[fucker_group] then
            for x = 1, #POSES_BY_GROUP[fucker_group], 1 do
			    table.insert(buttons, {text="Pose "..x, cb=function() self:DoRPCMonster(POSES_BY_GROUP[fucker_group][x]) end })
			end
		end
	end
    self.menu = self.proot:AddChild(Menu(buttons, button_w, true, "carny_long", nil, 30))
	
	if fucker_group == "player" then
        self.menu:SetPosition(-370, -190, 0)
	else
	    self.menu:SetPosition(-250, -190, 0)
	end
	
    for i,v in pairs(self.menu.items) do
        v:SetScale(.7)
    end
	
    local subbuttons = {}
	table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })
	if fucker_group == "player" then
	    table.insert(subbuttons, {text="Strip partner", cb=function() self:DoRPC("strip") end })
	end

    self.submenu = self.proot:AddChild(Menu(subbuttons, button_w, true, "carny_long", nil, 30))
    self.submenu:SetPosition(-90, -240, 0)
	
    for i,v in pairs(self.submenu.items) do
        v:SetScale(.7)
    end

    TheInputProxy:SetCursorVisible(true)
    self.default_focus = self.menu
end)

function SexPoseScreen:closemenu()
    TheInput:CacheController()
	self.active = false
    TheFrontEnd:PopScreen(self)
end

function SexPoseScreen:DoRPC(pose)
    SendModRPCToServer(MOD_RPC["LEWD"]["POSE"], ThePlayer, pose)
	self:closemenu()
end

function SexPoseScreen:DoRPCMonster(pose)
    SendModRPCToServer(MOD_RPC["LEWD"]["POSE_MONSTER"], ThePlayer, pose)
	self:closemenu()
end

function SexPoseScreen:OnControl(control, down)
    if SexPoseScreen._base.OnControl(self,control, down) then
       --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	   return true
    end
end

function SexPoseScreen:OnBecomeActive()
	SexPoseScreen._base.OnBecomeActive(self)
	TheFrontEnd:HideTopFade()
end

return SexPoseScreen
