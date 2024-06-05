local PutOn = Class(function(self, inst)
    self.inst = inst
end)

function PutOn:PutOn(doer)
    if self.inst and doer and doer.components.naked then   
		doer.sg:GoToState("puton_feet")
		doer.components.naked:PutOnClothing("stockings", self.inst.prefab)
		self.inst:Remove()
	end
	return true
end

return PutOn