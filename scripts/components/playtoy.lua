local PlayToy = Class(function(self, inst)
    self.inst = inst
end)

function PlayToy:Play(player,toy)	
	if not self.inst.dildo and toy ~= "rocket" then
	    player.AnimState:OverrideSymbol("toy", toy, "toy")
	    player.sg:GoToState("plush_toy")	
	else
	    if self.inst.dildo then
		    player.AnimState:OverrideSymbol("dick_other", toy, "dick")
			if self.inst.vibrator then
			    player.sg:GoToState("vibrating")
				player.fuckanim_client:set("vibrating")				    
			else
			    player.sg:GoToState("dilding")
				player.fuckanim_client:set("dilding_"..toy)	
			end	
		elseif toy == "rocket" then
		    player.AnimState:OverrideSymbol("rocket", "rocket_dick", "rocket")
			player.sg:GoToState("rocketfuck")	
		end
	end
	return true
end

function PlayToy:Fuck(player,toy)
    if player and toy and toy.components.sex then
	    toy.components.sex:FuckMonsterToy(player, toy)
	end
	return true
end

return PlayToy