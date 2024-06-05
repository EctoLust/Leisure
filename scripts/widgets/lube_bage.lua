local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Image = require "widgets/image"

local NumberToSay = {0,0}

local Lube_Bage = Class(Badge, function(self, owner)
    Badge._ctor(self, "lube_bage", owner)
	
    self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("effigy_topper")
    self.topperanim:GetAnimState():SetBuild("effigy_topper")
    self.topperanim:GetAnimState():PlayAnimation("anim")
    self.topperanim:SetClickable(false)

    self.sanityarrow = self.underNumber:AddChild(UIAnim())
    self.sanityarrow:GetAnimState():SetBank("sanity_arrow")
    self.sanityarrow:GetAnimState():SetBuild("sanity_arrow")
    self.sanityarrow:GetAnimState():PlayAnimation("neutral")
    self.sanityarrow:SetClickable(false)

    self.anim:GetAnimState():Hide("frame")

    self.name = self:AddChild(Text(BODYTEXTFONT, 20))
    self.name:SetHAlign(ANCHOR_MIDDLE)
    self.name:SetString("")
	
	self.name:SetPosition(0, 40, 0)
	
	function self.anim:OnControl(control, down)
		if control == CONTROL_ACCEPT then
			if down then
				self.down = true
			elseif self.down then
			    self.down = false
				TheNet:Say(STRINGS.LMB.."Lube: ("..NumberToSay[1].."/"..NumberToSay[2]..")", true)
			end
		end
	end
end)

function Lube_Bage:SetPercent(val, max, havesex)
    --Frv:
    --Fucking
	--Right
	--Val
    local frv = val/max
	NumberToSay = {val, max}
    Badge.SetPercent(self, max, frv)
    self.topperanim:GetAnimState():SetPercent("anim", 0)
	self.anim:GetAnimState():SetPercent("anim", 1-(frv/1))
	if havesex then
	    if self.arrow ~= "down" then
	        self.sanityarrow:GetAnimState():PlayAnimation("arrow_loop_decrease_more", true)
			self.arrow = "down"
		end
	else
	    self.sanityarrow:GetAnimState():PlayAnimation("neutral")
		self.arrow = "neutral"
	end
end

return Lube_Bage
