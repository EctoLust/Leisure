local Lube = Class(function(self, inst)
    self.inst = inst
	self.lubecount = 0
end)

function Lube:Use(doer)
    if self.inst and doer then   
		if doer.lube == nil then
		    doer.lube = 0
		end
		if doer.stickysalve == nil then
		    doer.stickysalve = 0
		end
		
		if not self.sticky then		
		    doer.lube = doer.lube+self.inst.components.lube.lubecount
			if doer.lube > 40 then
			    doer.lube = 40
			end
		else
		    doer.stickysalve = doer.stickysalve+self.inst.components.lube.lubecount
			if doer.stickysalve > 20 then
			    doer.stickysalve = 20
			end
		end
		if doer.components.moisture then
	        doer.components.moisture:DoDelta(5)
		end
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
	return true
end

return Lube