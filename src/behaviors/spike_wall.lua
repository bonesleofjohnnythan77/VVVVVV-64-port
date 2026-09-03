local rainbowTimer = 0
local r, g, b = 0, 0, 0

local function bhv_spike_wall_init(o)
    o.oFlags = 0x0041
    o.oCollisionDistance = 8000
    o.collisionData = smlua_collision_util_get("spike_wall_collision")
end

local function bhv_spike_wall_loop(o)
    load_object_collision_model()

    if gCheckpointTimer == 0 then
        o.oPosZ = o.oPosZ - 20.0
    end

    if gCheckpointTimer == 1 then
        o.oPosZ = gCheckpointPos.z + 2000
    end

    if rainbowTimer == 0 then
        r, g, b = 255, 0, 0
    end

    if rainbowTimer == 1530 then
        rainbowTimer = 0
    end

    local t5 = (rainbowTimer // 255) & 0xf
    rainbowTimer = rainbowTimer + 1

    if t5 == 0 then
        g = g + 1
    elseif t5 == 1 then
        r = r - 1
    elseif t5 == 2 then
        b = b + 1
    elseif t5 == 3 then
        g = g - 1
    elseif t5 == 4 then
        r = r + 1
    elseif t5 == 5 then
        b = b - 1
    end

    local cmd = gfx_get_command(gfx_get_from_name("wf_1_displaylist_0xe0267f0"), 6)
    gfx_set_command(cmd, "gsDPSetEnvColor(%i, %i, %i, 255)", r, g, b)

    cmd = gfx_get_command(gfx_get_from_name("wf_actor_geo_12000958_displaylist_0x701f608"), 6)
    gfx_set_command(cmd, "gsDPSetEnvColor(%i, %i, %i, 255)", r, g, b)
end

bhvSpikeWall = hook_behavior(nil, OBJ_LIST_SURFACE, true, bhv_spike_wall_init, bhv_spike_wall_loop, "bhvSpikeWall")