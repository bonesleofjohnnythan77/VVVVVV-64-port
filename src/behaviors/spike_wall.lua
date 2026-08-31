local function bhv_spike_wall_init(o)
    o.oFlags = 0x0041
    o.oCollisionDistance = 8000
    o.collisionData = smlua_collision_util_get("spike_wall_collision")
end

local function bhv_spike_wall_loop(o)
    load_object_collision_model()
end

bhvSpikeWall = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_spike_wall_init, bhv_spike_wall_loop, "bhvSpikeWall")