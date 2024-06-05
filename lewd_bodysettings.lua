
function GetGenderStrings(charactername)
    for gender,characters in pairs(GLOBAL.CHARACTER_GENDERS) do
        if table.contains(characters, charactername) then
            return gender
        end
    end
    return "DEFAULT"
end

GLOBAL.GetGenderStrings = function(charactername)
    for gender,characters in pairs(GLOBAL.CHARACTER_GENDERS) do
        if table.contains(characters, charactername) then
            return gender
        end
    end
    return "DEFAULT"
end

GLOBAL.GetDefaultTitsSize = function(prefab)
    -- This function set default tits size for editor
    if prefab == "wurt" then
	    return "none"	
    elseif prefab == "wendy" then
	    return "flat"
	elseif prefab == "willow" then
	    return "small"
	elseif prefab == "wickerbottom" or prefab == "winona" then
	    return "large"
	else
	    return "medium"
	end
end

GLOBAL.GetTitsBySize = function(prefab, tits)
    -- Wormla have only one tits size.
    if prefab == "wormla" then
	    return "wormla_nude"
	end
    if prefab == "wanda" then
	    return "wanda_nude"
	end	

	if tits == "flat" then
	    return "wendy_nude"
	elseif tits == "small" then
	    return "small_nude"
	elseif tits == "medium" then
	    return "willow_nude"
	elseif tits == "large" then
	    return "large_nude"
	elseif tits == "none" then	    
        return nil
	else
	    return nil
    end   
end

GLOBAL.HaveSeparatedTits = function(build)
    if build == "small_nude" or build == "willow_nude" or build == "large_nude" or build == "wormla_nude" or build == "wanda_nude" then
	    return true
	else
	    return false
	end
end

GLOBAL.GetDefaultDick = function(prefab, skin)
    -- If need check skin, and skin have specific dick.
    if skin ~= nil and skin ~= prefab.."_none" then
	    -- Webber
		if prefab == "webber" then		
		    if skin == "webber_bat_d" or skin == "webber_wrestler" then
	            return "webber_dick_brown"
	        elseif skin == "webber_ice" then
	            return "webber_dick_white"
            end	
        end		
	end
    -- If skin have not valid dick search dick by prefab.
	if prefab ~= "webber" and prefab ~= "wortox" and prefab ~= "wx78" and prefab ~= "walter" and prefab ~= "warly" then
	    return "white_dick"
	else  
		if prefab ~= "woodie" then
		    return prefab.."_dick"
		else
		    return "big_dick"
		end
	end
end

GLOBAL.CanChangeBoobsSize = function(build)
    if build == "wendy_nude" or build == "male_nude" then
	    return true
	else
	    return false
	end
end  

GLOBAL.GetNudeBuild = function(prefab)  
	if prefab == "wormla" then
	    return "wormla_nude"
	end
	if prefab == "wanda" then
	    return "wanda_nude"
	end	
	
	if prefab == "webber" or prefab == "wx78" or prefab == "wortox" or prefab == "wormwood" or prefab == "wurt" then
	    return ""
	else
	    if GetGenderStrings(prefab) == "FEMALE" then
		    return "wendy_nude"
		else
		    if prefab ~= "walter" and prefab ~= "warly" then
			    return "male_nude"
			elseif prefab == "walter" then
			    return "male_nude_brown"
			elseif prefab == "warly" then
		        return "male_nude_gray"
			end
		end
	end
end