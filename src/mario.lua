local deathSound = audio_stream_load("sound/sound_death.mp3")

local function mario_check_death(m)
    if m.playerIndex ~= 0 then
        return
    end

    if gCheckpointTimer == 0 then
        if m.floor and m.floor.type == 35 and (m.pos.y - m.floorHeight) <= 4000.0 then
            play_character_sound(m, CHAR_SOUND_WAAAOOOW)
            audio_stream_play(deathSound, false, 1)      
            m.hurtCounter = 1
        end
    end
end

local function mario_update_checkpoint(m)
    if m.playerIndex ~= 0 then
        return
    end

    if gCheckpointTimer ~= 0 then
        if gCheckpointTimer == 1 then
            vec3f_copy(m.pos, gCheckpointPos)

            m.flags = 16;
            m.action = 0x0C400201;
        end

        gCheckpointTimer = gCheckpointTimer - 1
    end

    if m.hurtCounter >= 1 then
        audio_stream_play(deathSound, false, 1)
        
        m.flags = 20;
        m.hurtCounter = 0;
        gCheckpointTimer = 23;
    end
end

function mario_wrap_y_pos(m)
    if m.floor and m.floor.type == 46 then
        if (m.pos.y - m.floorHeight) <= 75.0 then
            m.pos.y = m.ceilHeight - 160
            m.action = 0x0100088C
        end
    end
end

local function mario_update(m)
    m.health = 2176
    m.peakHeight = m.pos.y

    mario_check_death(m)
    mario_update_checkpoint(m)
    mario_wrap_y_pos(m)
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
