local CumAttachable = Class(function(self, inst)
    self.inst = inst
	self.symbol = "face"
	self.cum = {}
	self.symbols = {}
	self.lastlayer = nil
end)

function CumAttachable:GetCum()
	return #self.cum 
end

function CumAttachable:HaveCum(symb)
	if self.symbols[symb] == nil then
	    return false
	else
	    return true
	end
end

-- Description for "inst.AnimState:GetCurrentFacing()" 
--Down 3
--Up 1
--Left 2
--Right 0

local cum_x = {}
cum_x["face"] = -38
cum_x["torso"] = 0

local cum_y = {}
cum_y["face"] = 0
cum_y["torso"] = -20

function CumAttachable:AddCum(fem, robo, symbol)
    local cum = SpawnPrefab("cumnew")
	
	if fem then
	    local num = math.random(7)
	    cum.AnimState:PlayAnimation(num.."_front")		
	end
	if robo then
	    cum.AnimState:SetMultColour(0, 0, 0, 1)
	end
	if symbol == nil then
	    symbol = self.symbol
	end
	
	if symbol == "torso" then
	    local size = 0.7
	    cum.Transform:SetScale(size,size,size)
	end
	
	cum.entity:SetParent(self.inst.entity) 
    cum.entity:AddFollower()
    
    if self.lastlayer ~= nil then
	    self:ChangeLayer(self.lastlayer)
    end
    if self.symbols[symbol] == nil then
	    self.symbols[symbol] = true
    end	
    
	cum:DoPeriodicTask(0, function()
	    local face = self.inst.AnimState:GetCurrentFacing()
		
		if self.inst.partner or self.inst.sg:HasStateTag("fap") or self.inst.sg:HasStateTag("fuck")  then
		    face = 3
		end
		
		local x = 0
		local y = cum_y[symbol]
		if face == 2 or face == 0 then
			x = cum_x[symbol]		
		end
		cum.Follower:FollowSymbol(self.inst.GUID, symbol, x, y, 0)
	end)
	
    table.insert(self.cum, cum)
end

function CumAttachable:ChangeLayer(layer)
    self.lastlayer = layer
    for x = 1, #self.cum, 1 do
        self.cum[x].AnimState:SetLayer(layer)
		if layer == LAYER_WORLD then
		    self.cum[x].AnimState:SetSortOrder(0)	
		else
		    self.cum[x].AnimState:SetSortOrder(5)
		end
    end
end

function CumAttachable:RemoveCum()
    for x = 1, #self.cum, 1 do
        self.cum[x]:Remove()
    end
	self.cum = {}
	self.symbols = {}
end

return CumAttachable