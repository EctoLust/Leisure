local function NakedAround(inst)
    return 0 -- Kept at 0 for controlled solo play progression
end

local Excited = Class(function(self, inst)
    self.inst = inst
	self.libido = 0
	self.libidomax = 100 
	self.daysnosex = 0
	self.enable = false
	self.springfever = false
	self.warned = false -- Initialized state tracker
	
	self.inst:DoPeriodicTask(6, function() -- Every 6 seconds
		 -- Balanced filling/decay logic
		 if not self.inst.sg:HasStateTag("fuck") and not self.inst.sg:HasStateTag("fap") then
			 if self.daysnosex >= 5 then
                 -- Perfectly calibrated: Adds 5 points per real minute. Takes exactly 20 minutes to hit 100.
                 self.libido = self.libido + 0.5 
             else
                 -- Normalizes your state and prevents the stuck down-arrow glitch
                 if self.libido > 0 then 
                     self.libido = self.libido - 0.5 
                 end
             end
		 end
		 
		 -- The comfortable clearing speed you liked
		 if self.inst.sg:HasStateTag("fap") or self.inst.sg:HasStateTag("friendlyfuck") then
			 self.libido = self.libido - 15 
             self.daysnosex = 0 -- CRITICAL FIX: Resets the day tracker so the UI arrow doesn't bug out!
		 end
		 
		 -- Boundaries check
	     if self.libido < 0 then  self.libido = 0 end
	     if self.libido > 100 then self.libido = self.libidomax end
	     
	     -- =========================================================
	     -- CALIBRATED BUFFS & SANITY PENALTIES (TRIGGERS AT 75+)
	     -- =========================================================
	     if self.inst.components.locomotor and self.inst.components.combat and self.inst.components.sanity then
		     if self.libido >= 90 then
		         -- PEAK FRENZY STATE: +20% Speed, +25% Damage Multiplier
		         self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "libido_speed", 1.20)
		         self.inst.components.combat.externaldamagemultipliers:SetModifier(self.inst, 1.25, "libido_buff")
		         
		         -- OVERWHELMING DRAIN: -40 Sanity/min (-4.0 every 6s). Flower hat (+1.33) won't save you.
		         self.inst.components.sanity:DoDelta(-4.0)
		         
		         -- AUDIO WARNING: Play the heavy heartbeat sound every 6 seconds while in danger zone
		         if self.inst.SoundEmitter then
		             self.inst.SoundEmitter:PlaySound("dontstarve/sanity/heartbeat")
		         end
		         
		         -- TEXT WARNING: Text bubble appears once when first hitting 90+
		         if not self.warned and self.inst.components.talker then
		             self.inst.components.talker:Say("I... I can't think straight... I need to fuck!")
		             self.warned = true
		         end
		         
		     elseif self.libido >= 75 then
		         -- HIGH STATE: +10% Speed, No Damage Multiplier
		         self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "libido_speed", 1.10)
		         self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst, "libido_buff")
		         
		         -- VERY SLOW TICK: -3 Sanity/min (-0.3 every 6s). Completely manageable.
		         self.inst.components.sanity:DoDelta(-0.3)
		         
		         -- Reset text warning trigger so it can fire again if they bounce back up to 90
		         self.warned = false 
		         
		     else
		         -- SAFE ZONE (BELOW 75): Nothing happens. Clean up all buffs/penalties.
		         self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "libido_speed")
		         self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst, "libido_buff")
		         self.warned = false
		         
		         -- Stop the heartbeat sound completely if it's lingering
		         if self.inst.SoundEmitter then
		             self.inst.SoundEmitter:KillSound("dontstarve/sanity/heartbeat")
		         end
		     end
		 end
	end)
	
	self.inst:WatchWorldState("cycles", function()
	     self.daysnosex = self.daysnosex+1
	end)
	
	-- Safety cleanup
	self.inst:ListenForEvent("onremove", function()
        if self.inst.components.locomotor then
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "libido_speed")
        end
        if self.inst.components.combat then
            self.inst.components.combat.externaldamagemultipliers:RemoveModifier(self.inst, "libido_buff")
        end
	end)
end)

function Excited:SetEnable(toggle)
    self.enable = toggle
end

function Excited:OnSave()
    return {libido = self.libido, nosex = self.daysnosex}, nil
end

function Excited:OnLoad(data)
    if data ~= nil then
        if data.libido then
		    self.libido = data.libido
		end
		if data.nosex then
		    self.daysnosex = data.nosex
		end
    end
end

return Excited