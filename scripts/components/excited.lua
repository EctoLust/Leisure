local function NakedAround(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	local nudes = TheSim:FindEntities(x,y,z,8) 
	local count = 0
	for k,obj in pairs(nudes) do
	    if obj ~= inst and obj ~= inst.partner and obj.components.naked then	
			if obj.components.naked:IsNaked("body") or obj.components.naked:IsNaked("legs") then -- Naked +2
			    count = count+2
				if obj.sg:HasStateTag("dancing") then -- Sexy dance +2
				    count = count+2
				end
			end
			if obj.sg:HasStateTag("fuck") or obj.sg:HasStateTag("suck") then -- Have Sex +3*2 cause two players will be seen.
			    count = count+3
            elseif obj.sg:HasStateTag("fap") then -- Someone fap +3
                count = count+3		
			end
		end
    end	

	return count
end

local Excited = Class(function(self, inst)
    self.inst = inst
	self.libido = 0
	self.libidomax = 100 
	self.daysnosex = 0
	self.enable = false
	self.springfever = false
	self.inst:DoPeriodicTask(6, function() -- Every 6 seconds -1 is 10 minutes
		 local nudes = 0          
		 if not self.inst.sg:HasStateTag("fuck") and not self.inst.sg:HasStateTag("fap") then
             nudes = NakedAround(self.inst)				 
			 if nudes == 0 then
			     if self.springfever then
				     self.libido = self.libido+1
				 end
				 if self.daysnosex <= 3 and self.libido > 0 then
			         self.libido = self.libido-1
			     end
			     if self.daysnosex >= 5 then
			         self.libido = self.libido+1
			     end
			     if self.daysnosex >= 7 then
			         self.libido = self.libido+2
			     end				 
			 end
		 end
		 if nudes > 0 then
			 self.libido = self.libido+nudes
		 end
	     if self.libido > 100 then
			 self.libido = self.libidomax
	     end
	     if self.libido > 90 then
			 self.inst.components.sanity:DoDelta(-1)
	     end
	end)
	self.inst:WatchWorldState("cycles", function()
	     self.daysnosex = self.daysnosex+1
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