local SimpleRead = Class(function(self, inst)
    self.inst = inst
	self.onused = nil
	self.brackable = true
	self.hascooldown = false
	self.cooldown = 0
	self.cooldownmax = 30
end)

function SimpleRead:Use(doer)
    if self.inst and doer then  
        if self.onused ~= nil then
            self.onused(self.inst, doer)
        end	
		if self.brackable then
		    if self.inst.components.finiteuses then
		        self.inst.components.finiteuses:Use()
		    else
		        if self.inst.components.stackable ~= nil then
                    self.inst.components.stackable:Get():Remove()
                else
                    self.inst:Remove()
                end
		    end
		end
	end
	return true
end

return SimpleRead