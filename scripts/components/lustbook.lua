local Lube = Class(function(self, inst)
    self.inst = inst
	self.lubecount = 0
end)

function Lube:Use(doer)
    doer.lustbook_client:push()
	return true
end

return Lube