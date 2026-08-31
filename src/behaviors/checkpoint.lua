gCheckpointPos = gVec3fZero()
gCheckpointTimer = 0

local checkpointYaw = 0
local checkpointFloorSomething = 0

local function bhv_checkpoint_init(o)
    o.oFlags = 0x0001
    o.oIntangibleTimer = 0
    o.oInteractStatus = 0

    o.hitboxRadius = 80
    o.hitboxHeight = 10
end

local function bhv_checkpoint_loop(o)
    if (obj_check_if_collided_with_object(o, gMarioStates[0].marioObj)) ~= 0 then
        vec3f_set(gCheckpointPos, o.oPosX, o.oPosY, o.oPosZ)

        checkpointYaw = o.oFaceAngleYaw

       -- sCheckpointFloorSomething = *(u32 *)0x8033C6A8; Unused
    end
end

bhvCheckpoint = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_checkpoint_init, bhv_checkpoint_loop, "bhvCheckpoint")

local function bhv_checkpoint_marker_init(o)
    o.oFlags = 0x0001
end

local function bhv_checkpoint_marker_loop(o)
    obj_set_pos(o, gCheckpointPos.x, gCheckpointPos.y, gCheckpointPos.z)
    o.oFaceAngleYaw = checkpointYaw
    o.header.gfx.inited = false -- stop interpolation

    -- floor check was moved to mario.lua, so hurtCounter is set at the right time!
end

bhvCheckpointMarker = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_checkpoint_marker_init, bhv_checkpoint_marker_loop, "bhvCheckpoint")