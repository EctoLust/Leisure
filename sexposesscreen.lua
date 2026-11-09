local Screen = require "widgets/screen" -- Changed to screen to match fallback structure
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

    self.active = true

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
    local button_w = 160
    local button_h = 50
	
    self.title = self.proot:AddChild(Text(BUTTONFONT, 50))
    self.title:SetPosition(0, 170, 0)
    self.title:SetString("What pose you want?")
    self.title:SetColour(1,1,1,1)
	
    local fucker_name = ThePlayer.fuckerprefab_client:value()
    local fucker_group = GetPosesGroup(fucker_name)
	
    -- FIX: Fully kill the screen generation process immediately if pressed outside an animation
    if fucker_name == "" or fucker_group == "" then
        TheInput:CacheController()
        self.active = false
        -- Delay the pop by one frame so the game doesn't crash on an empty stack
        self.inst:DoTaskInTime(0, function() TheFrontEnd:PopScreen(self) end)
        return -- CRITICAL: Stops the rest of the code from executing and creating the ghost menus!
    end	

    -- 1. Poses ONLY go in the buttons array
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

    -- 2. Utility options ONLY go into the subbuttons array
    local subbuttons = {}
    table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })
	if fucker_group == "player" then
	    table.insert(subbuttons, {text="Strip partner", cb=function() self:DoRPC("strip") end })
	end

    -- Main Menu initialization (horizontal)
    self.menu = self.proot:AddChild(Menu(buttons, button_w, true, "carny_long", nil, 30))
    self.menu:SetPosition(fucker_group == "player" and -370 or -250, -190, 0)
	
    -- Submenu initialization (horizontal)
    self.submenu = self.proot:AddChild(Menu(subbuttons, button_w, true, "carny_long", nil, 30))
    self.submenu:SetPosition(-90, -240, 0)
	
    for i,v in pairs(self.menu.items) do v:SetScale(.7) end
    for i,v in pairs(self.submenu.items) do v:SetScale(.7) end

    -- SAFEST NAVIGATION GRID WIRING (Item-To-Item Array Safeguard)
    if TheInput:ControllerAttached() then
        -- Vertical paths between Poses row (self.menu) and Actions row (self.submenu)
        -- Links Pose 1 to Close, and Pose 2 to Strip Partner. All other poses default down to Strip.
        for i, item in ipairs(self.menu.items) do
            if i == 1 and self.submenu.items[1] then
                item:SetFocusChangeDir(MOVE_DOWN, self.submenu.items[1])
            elseif self.submenu.items[2] then
                item:SetFocusChangeDir(MOVE_DOWN, self.submenu.items[2])
            elseif self.submenu.items[1] then
                item:SetFocusChangeDir(MOVE_DOWN, self.submenu.items[1])
            end
        end

        -- Links the Close and Strip buttons back up to the first two Poses
        if self.submenu.items[1] and self.menu.items[1] then
            self.submenu.items[1]:SetFocusChangeDir(MOVE_UP, self.menu.items[1])
        end
        if self.submenu.items[2] and self.menu.items[2] then
            self.submenu.items[2]:SetFocusChangeDir(MOVE_UP, self.menu.items[2])
        end

        -- Bounded dead-ends so horizontal clicks don't leak into empty space
        if self.menu.items[1] then self.menu.items[1]:SetFocusChangeDir(MOVE_LEFT, self.menu.items[1]) end
        if self.menu.items[#self.menu.items] then self.menu.items[#self.menu.items]:SetFocusChangeDir(MOVE_RIGHT, self.menu.items[#self.menu.items]) end
        
        if self.submenu.items[1] then self.submenu.items[1]:SetFocusChangeDir(MOVE_LEFT, self.submenu.items[1]) end
        if self.submenu.items[#self.submenu.items] then self.submenu.items[#self.submenu.items]:SetFocusChangeDir(MOVE_RIGHT, self.submenu.items[#self.submenu.items]) end
    end

    TheInputProxy:SetCursorVisible(true)
    -- === CHANGE THIS TARGET TO REFLECT THE EXACT BASE ELEMENT FOR HIGHLIGHTING ===
    self.default_focus = self.menu.items[1]
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
    if SexPoseScreen._base.OnControl(self, control, down) then
        return true
    end

    -- FIXED HARDWARE CONTROLLER ACTION CAPTURE
    if down and (control == 0 or control == 1) then -- 0 is Accept/A, 1 is Primary/Action
        -- Check primary menu buttons
        if self.menu and self.menu.items then
            for i, item in ipairs(self.menu.items) do
                if item.focus then
                    if item.onclick then item.onclick() return true end
                    if item.cb then item.cb() return true end
                end
            end
        end
        -- Check submenu buttons (Close / Strip partner)
        if self.submenu and self.submenu.items then
            for i, item in ipairs(self.submenu.items) do
                if item.focus then
                    if item.onclick then item.onclick() return true end
                    if item.cb then item.cb() return true end
                end
            end
        end
    end

    -- Allow standard D-Pad / Thumbstick navigation between choices
    if self.menu and self.menu:OnControl(control, down) then
        return true
    elseif self.submenu and self.submenu:OnControl(control, down) then
        return true
    end

    -- Controller Back/B button safely closes the UI panel (2 is Cancel/B)
    if down and control == 2 then
        self:closemenu()
        return true
    end

    return false
end

function SexPoseScreen:OnBecomeActive()
    SexPoseScreen._base.OnBecomeActive(self)
    TheFrontEnd:HideTopFade()
    
    -- Safety Fallback: If screen somehow spawns without a valid target, clear it instantly
    local fucker_name = ThePlayer.fuckerprefab_client and ThePlayer.fuckerprefab_client:value() or ""
    if fucker_name == "" then
        self:closemenu()
        return
    end

    if self.menu and self.menu.items and self.menu.items[1] then
        self.menu.items[1]:SetFocus()
    elseif self.menu then
        self.menu:SetFocus()
    end
end

return SexPoseScreen