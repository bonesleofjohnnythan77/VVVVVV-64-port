-- Lua Translated Behavior Code

--Checkpoint code (translated to Lua)

die_audio = audio_stream_load("sound/v_die.mp3")
sCheckpointPos = gVec3fZero()
sCheckpointTimer = 0
sCheckpointYaw = 0
sCheckpointFloorSomething = 0

function bhv_checkpoint_loop(o) 
    if (obj_check_if_collided_with_object(o, gMarioStates[0].marioObj)) ~= 0 then
        vec3f_set(sCheckpointPos, o.oPosX, o.oPosY, o.oPosZ)

        sCheckpointYaw = o.oFaceAngleYaw

       -- sCheckpointFloorSomething = *(u32 *)0x8033C6A8; Unused
    end
end

function bhv_checkpoint_marker(o)
    o.oPosX = sCheckpointPos.x
    o.oPosY = sCheckpointPos.y
    o.oPosZ = sCheckpointPos.z
    o.oFaceAngleYaw = sCheckpointYaw

    if sCheckpointTimer == 0 then
        local m = gMarioStates[0]
        if m.playerIndex ~= 0 then return end
        if m.floor.type == 35 and (m.pos.y - m.floorHeight) <= 4000.0 then
            audio_stream_play(die_audio, false, 1)
            m.hurtCounter = 5
        end
    end
end

function mario_checkpoint_update(m)

if m.playerIndex ~= 0 then return end
--djui_chat_message_create(tostring(m.floor.type))

    m.health = 2176;

    if sCheckpointTimer ~= 0 then
        if sCheckpointTimer == 1 then
            m.pos.x = sCheckpointPos.x;
            m.pos.y = sCheckpointPos.y;
            m.pos.z = sCheckpointPos.z;



            m.flags = 16;
            m.action = 0x0C400201;
        end

        sCheckpointTimer = sCheckpointTimer - 1
    end

    if (m.hurtCounter >= 1) then
        audio_stream_play(die_audio, false, 1)
        m.flags = 20;
        m.hurtCounter = 0;
        sCheckpointTimer = 23;
    end
end

function bhv_mario_height_update(o)
    local m = gMarioStates[0]
    if m.playerIndex ~= 0 then return end

    if m.floor ~= 0 and m.floor.type == 46 then

        if (m.pos.y - m.floorHeight) <= 75.0 then
            
            m.pos.y = m.peakHeight - 160

            m.action = 0x0100088C

        end

    end
    
end

hook_event(HOOK_BEFORE_MARIO_UPDATE, mario_checkpoint_update)