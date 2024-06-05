
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

GLOBAL.GetNudeBuildOptions = function(not_include_none)
    local array = {}
	if not_include_none == nil or not_include_none == false then
	    table.insert(array, { text = "None", data = "" })
	end
	table.insert(array, { text = "White female", data = "wendy_nude" })
	table.insert(array, { text = "White male", data = "male_nude" })
    table.insert(array, { text = "Tan male", data = "male_nude_brown" })	
	table.insert(array, { text = "Tan female", data = "wanda_nude" })
	table.insert(array, { text = "Gray male", data = "male_nude_gray" })
	table.insert(array, { text = "Plant tiddy", data = "wormla_nude" })
	return array
end

GLOBAL.GetPossibleDisguiseCandiates = function(not_include_none)
    local CharsList = GetActiveCharacterList()
	local data = {}
	if not_include_none == nil or not_include_none == false then
	    table.insert(data, { text = "None", data = "" })
	end
	for x = 1,#CharsList,1 do
	    if CharsList[x] ~= nil and IsCharacterOwned(CharsList[x]) then
			table.insert(data, { text = STRINGS.NAMES[string.upper(CharsList[x])], data = CharsList[x]})
		end
	end
	return data
end


GLOBAL.VoiceReferenceTable = {}
--print(GetReferenceVoiceData("willow").voicename)
--print(GetReferenceVoiceData("wormla").voicename)
GLOBAL.GetReferenceVoiceData = function(prefab) 
    if #GLOBAL.VoiceReferenceTable == 0 then
	    GLOBAL.RegisterVoiceReferenceTable()
	end
	for x = 1,#GLOBAL.VoiceReferenceTable,1 do
	    local VoiceData = GLOBAL.VoiceReferenceTable[x] 
		if VoiceData ~= nil then
		    if prefab == VoiceData.prefabname then
			    return VoiceData
			end
		end
	end
	return nil
end

GLOBAL.RegisterVoiceReferenceTable = function()  
    local CharsList = GetActiveCharacterList()
	for x = 1,#CharsList,1 do
	    local prefab = CharsList[x] 
		if prefab ~= nil then
		    local Char = GLOBAL.SpawnPrefab(prefab)
			if Char ~= nil then	
   			    local voice = Char.soundsname
   				local font = nil
				local talkeroverride = Char.talker_path_override
   				if Char.components.talker then
   				    font = Char.components.talker.font
   				end
		        if voice == nil then
		           voice = prefab
		        end
   				table.insert(GLOBAL.VoiceReferenceTable, { prefabname = prefab, voicename = voice, fontname = font, pathoverride = talkeroverride, customidle = Char.customidleanim })
   				Char:Remove()				
			end
		end
	end
end