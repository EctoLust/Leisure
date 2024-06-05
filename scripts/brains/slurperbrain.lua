require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chaseandattack"
require "behaviours/follow"

local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 6
local MAX_WANDER_DIST = 10

local function GetLeader(inst)
    return inst.components.follower.leader
end

local function GetFollowPos(inst)
    return inst.components.follower.leader and inst.components.follower.leader:GetPosition() or
    inst:GetPosition()
end

local SlurperBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function SlurperBrain:OnStart()    
    local root = PriorityNode(
    {
    	WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        ChaseAndAttack(self.inst, 60, 100),
        Wander(self.inst, GetFollowPos, MAX_WANDER_DIST),   
        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
    }, .25)
    self.bt = BT(self.inst, root)
end

return SlurperBrain