local require = GLOBAL.require
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIFONT = GLOBAL.UIFONT

local lube_bage = GLOBAL.require("widgets/lube_bage")
local sticky_bage = GLOBAL.require("widgets/sticky_bage")
local libido_bage = GLOBAL.require("widgets/libido_bage")
local PlayerProfile = GLOBAL.require("playerprofile")

function string:split_adv( inSplitPattern, outResults )
    if not outResults then
        outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
        table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end


local tNet = GLOBAL.getmetatable(GLOBAL.TheNet).__index

local _GetClientTableForUser = tNet.GetClientTableForUser
tNet.GetClientTableForUser = function(_, id, ...)
	--print("GetClientTableForUser("..tostring(id)..")")
	local data = _GetClientTableForUser(_, id, ...)
	if data then
	    local prefab = GLOBAL.GetClientDisguise(id)
		--print("GetClientDisguise("..tostring(id)..") -> "..prefab)
		if prefab ~= "" then
			data.prefab = prefab
		    data.base_skin = prefab.."_none"	
		end
	end
	return data
end

local _GetClientTable = tNet.GetClientTable
tNet.GetClientTable = function(...)
	local ClientObjs = _GetClientTable(...) or {}
    for i, client in ipairs(ClientObjs) do
	    local prefab = GLOBAL.GetClientDisguise(client.userid)
		if prefab ~= "" then
			client.prefab = prefab
		    client.base_skin = prefab.."_none"
		end
    end
	return ClientObjs
end

GLOBAL.DisguiseTable = {}
GLOBAL.SetClientDisguise = function(_id, _prefab)
    print("SetClientDisguise("..tostring(_id)..", ".._prefab..")")
	for i, client in ipairs(GLOBAL.DisguiseTable) do
		if client.id == _id then
		    client.prefab = _prefab
			return
		end
    end
	table.insert(GLOBAL.DisguiseTable, {id = _id, prefab = _prefab})
end

GLOBAL.GetClientDisguise = function(_id)
    for i, client in ipairs(GLOBAL.DisguiseTable) do
		if client.id == _id then
			return client.prefab
		end
    end
	return ""
end

GLOBAL.ClientChangedDisguise = function(_id, _prefab, debugstring)
    if debugstring == nil then
	    debugstring = "unknown"
	end
	if GLOBAL.TheWorld.ismastersim then
	    print("ClientChangedDisguise("..tostring(_id)..", ".._prefab..", "..debugstring..")")		
		for k,player in pairs(GLOBAL.AllPlayers) do
		    player.disguisetable_client:set(_id.."#".._prefab)
		end
    end
end

GLOBAL.RegisterDisguiseNetHook = function(inst)
	inst.disguisetable_client = GLOBAL.net_string(inst.GUID, "disguisetable.client", "disguisetable_clientdirty")
	if not GLOBAL.TheNet:IsDedicated() then
	    inst:ListenForEvent("disguisetable_clientdirty", function()
		    print("World:ListenForEvent -> disguisetable_clientdirty")
		    local datastring = inst.disguisetable_client:value()
		    local splitdata = datastring:split_adv("#")
		    GLOBAL.SetClientDisguise(splitdata[1], splitdata[2])
	    end)
	    --print("DisguiseNetHook has been registered!")	
	end
end