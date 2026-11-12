local PutOn = Class(function(self, inst)
    self.inst = inst
end)

function PutOn:PutOn(doer)
    if self.inst and doer and doer.components.naked then   
		doer.sg:GoToState("puton_feet")
		
		local old_socks = doer.components.naked.clothing and doer.components.naked.clothing["stockings"] or doer.components.naked.stockings
		if old_socks and old_socks ~= "" and Prefabs[old_socks] then
			doer.components.inventory:GiveItem(SpawnPrefab(old_socks))
		end
		
		doer.components.naked:PutOnClothing("stockings", self.inst.prefab)
		self.inst:Remove()
	end
	return true
end

return PutOn