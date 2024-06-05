local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Image = require "widgets/image"

local NumberToSay = {0,0}

local Libido_Bage = Class(Badge, function(self, owner)
	Badge._ctor(self, nil, owner, { 255 / 255, 255 / 255, 255 / 255, 1 }, "status_libido")

    self.sanityarrow = self.underNumber:AddChild(UIAnim())
    self.sanityarrow:GetAnimState():SetBank("sanity_arrow")
    self.sanityarrow:GetAnimState():SetBuild("sanity_arrow")
    self.sanityarrow:GetAnimState():PlayAnimation("neutral")
    self.sanityarrow:SetClickable(false)

    self.anim:GetAnimState():Hide("frame")

	function self.anim:OnControl(control, down)
		if control == CONTROL_ACCEPT then
			if down then
				self.down = true
			elseif self.down then
			    self.down = false
				TheNet:Say(STRINGS.LMB.."Libido: ("..NumberToSay[1].."/"..NumberToSay[2]..")", true)
			end
		end
	end
end)

function Libido_Bage:SetPercent(val, max, havesex, fap)
    --Frv:
    --Fucking
	--Right
	--Val
    local frv = val/max
	NumberToSay = {val, max}
    Badge.SetPercent(self, max, frv)
	self.anim:GetAnimState():SetPercent("anim", 1-(frv/1))
	if havesex then
	    if self.arrow ~= "down_alot" then
	        self.sanityarrow:GetAnimState():PlayAnimation("arrow_loop_decrease_more", true)
			self.arrow = "down_alot"
		end
	elseif fap then
	    if self.arrow ~= "down" then
	        self.sanityarrow:GetAnimState():PlayAnimation("arrow_loop_decrease", true)
			self.arrow = "down"
		end	
	else
	    self.sanityarrow:GetAnimState():PlayAnimation("neutral")
		self.arrow = "neutral"
	end
end

return Libido_Bage
