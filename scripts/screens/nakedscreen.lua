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

local NakedScreen = Class(Screen, function(self)
    Screen._ctor(self, "NakedScreen")

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
    self.title:SetString("What you want to take off?")
    self.title:SetColour(1,1,1,1)

    local buttons = {}
    table.insert(buttons, {text="Body", cb=function() self:DoRPC("body") end })
	table.insert(buttons, {text="Gloves", cb=function() self:DoRPC("hand") end })
	table.insert(buttons, {text="Legs", cb=function() self:DoRPC("legs") end })
	table.insert(buttons, {text="Shoes", cb=function() self:DoRPC("feet") end })
	--table.insert(buttons, {text="Close", cb=function() self:closemenu() end })

    self.menu = self.proot:AddChild(Menu(buttons, button_w, true, "carny_long", nil, 30))
    self.menu:SetPosition(-250, -190, 0)
	
    for i,v in pairs(self.menu.items) do
        v:SetScale(.7)
    end
	
    local subbuttons = {}
    table.insert(subbuttons, {text="Close", cb=function() self:closemenu() end })
	table.insert(subbuttons, {text="Stockings", cb=function() self:DoRPC("stockings") end })
	table.insert(subbuttons, {text="Take off all", cb=function() self:DoRPC("all") end })

    self.submenu = self.proot:AddChild(Menu(subbuttons, button_w, true, "carny_long", nil, 30))
    self.submenu:SetPosition(-90, -240, 0)
	
    for i,v in pairs(self.submenu.items) do
        v:SetScale(.7)
    end

    TheInputProxy:SetCursorVisible(true)
    self.default_focus = self.menu
	self:UpdateButtons()
end)

function NakedScreen:closemenu()
    TheInput:CacheController()
    if TheCamera then
	    TheCamera:SetDistance(20)
	end
	self.active = false
    TheFrontEnd:PopScreen(self)
end

function NakedScreen:DoRPC(typeoff)
    SendModRPCToServer(MOD_RPC["LEWD"]["TAKEOFF"], ThePlayer, typeoff)
end

local hand = false
local body = false	
local legs = false
local feet = false
local hand_last = false
local body_last = false	
local legs_last = false
local feet_last = false

function NakedScreen:OnUpdate(dt)
	if ThePlayer.nudehand_client then
	    hand = ThePlayer.nudehand_client:value()
	end
	if ThePlayer.nudebody_client then
	    body = ThePlayer.nudebody_client:value()
	end
	if ThePlayer.nudelegs_client then
	    legs = ThePlayer.nudelegs_client:value()
	end
	if ThePlayer.nudefeet_client then
	    feet = ThePlayer.nudefeet_client:value()
	end     
	if hand ~= hand_last or body ~= body_last or legs ~= legs_last or feet ~= feet_last then
	    self:UpdateButtons()
	end
end


function NakedScreen:UpdateButtons()	
	hand_last = hand
	body_last = body
	legs_last = legs
	feet_last = feet
	
	if self.submenu.items then
	    if self.submenu.items[3] then
		    if not body and not hand and not legs and not feet then
			    self.submenu.items[3]:Enable() 
			else
			    self.submenu.items[3]:Disable()
			end
		end
	end
	if self.menu.items then
        for i,v in pairs(self.menu.items) do
            local btntext = v:GetText()
			if btntext == "Body" then
			    if not body then
				    v:Enable()   
				else
				    v:Disable()
				end
			elseif btntext == "Gloves" then
			    if not hand then
				    v:Enable()   
				else
				    v:Disable()
				end	
			elseif btntext == "Legs" then
			    if not legs then
				    v:Enable()   
				else
				    v:Disable()
				end	
			elseif btntext == "Shoes" then
			    if not feet then
				    v:Enable()   
				else
				    v:Disable()
				end					
			end
        end
	end 
end

function NakedScreen:OnControl(control, down)
    if NakedScreen._base.OnControl(self,control, down) then
       --TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	   return true
    end
end

function NakedScreen:OnBecomeActive()
	NakedScreen._base.OnBecomeActive(self)
	TheFrontEnd:HideTopFade()
end

return NakedScreen
