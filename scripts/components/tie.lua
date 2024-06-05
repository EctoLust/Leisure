
local item_root = nil

local Tie = Class(function(self, inst)
    self.inst = inst
	item_root = self.inst
end)

local function RopeIt(victim, roper)
	if victim and roper and victim.sg:HasStateTag("idle") and victim:GetDistanceSqToInst(roper) < 7 then
	    victim:AddTag("ropped")
		victim:PushEvent("knockedout")
        if victim.roppedtask ~= nil then
            victim.roppedtask:Cancel()
        end
        victim.roppedtask = victim:DoTaskInTime(5, function() if victim.sg:HasStateTag("knockout") then victim.sg:GoToState("wakeup") end end)
        if item_root and item_root.components.stackable ~= nil then
            item_root.components.stackable:Get():Remove()
        else
            item_root:Remove()
        end
        roper.components.talker:Say("Catch ya!")
	else
		roper.components.talker:Say("Wait a moment please...")
	end
end

local function FindToTie(roper)
    local target = FindEntity(roper, 4, function(item) 
    return item:HasTag("tieable") end, nil,{ "" } )
    if target ~= nil then
        RopeIt(target, roper)  
	else
	    roper.components.talker:Say("No one close.")
	end
end

function Tie:Tie(roper)
    FindToTie(roper)
	return true
end

return Tie