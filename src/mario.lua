local function get_character_number(m)
    if charSelectExists then
        return charSelect.character_get_current_number(m.playerIndex)
    end

    return m.character.type
end

local function mario_check_death(m)
    if m.playerIndex ~= 0 then
        return
    end

    if gCheckpointTimer == 0 then
        if m.floor and m.floor.type == 35 and (m.pos.y - m.floorHeight) <= 4000.0 then
            play_character_sound(m, CHAR_SOUND_WAAAOOOW)
            m.hurtCounter = 1
        end
    end
end

local function mario_update_checkpoint(m)
    if m.playerIndex ~= 0 then
        return
    end
    local s  = gPlayerSyncTable[m.playerIndex]
    if gCheckpointTimer ~= 0 then
        if gCheckpointTimer == 1 then
            vec3f_copy(m.pos, gCheckpointPos)
            m.flags = 16;
            m.action = 0x0C400201;
        end
        s.fixTimer = s.fixTimer - 1
        gCheckpointTimer = gCheckpointTimer - 1
    end

    if m.hurtCounter >= 1 then
        --audio_stream_play(deathSound, false, 1)

        local char = get_character_number(m)

        if char < CT_MAX then
            m.flags = 20;
        end
        m.hurtCounter = 0;
        s.fixTimer = 23;
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

function mario_palette_swap(m)
    local s  = gPlayerSyncTable[m.playerIndex]
    local np = gNetworkPlayers[m.playerIndex]
    if not np.connected then return end


    djui_chat_message_create("" .. s.fixTimer)


    for i = 0, PLAYER_PART_MAX - 1 do
        if s.fixTimer ~= 0 then
            network_player_set_override_palette_color(np, i, { r = 255, g = 0, b = 0 })
            djui_chat_message_create("poinrt")
        end
        if s.fixTimer == math.abs(1) then
            network_player_reset_override_palette(np)
        end
    end
end


local function mario_update(m)
    m.health = 2176
    m.peakHeight = m.pos.y
    m.marioObj.hookRender = 1
    mario_check_death(m)
    mario_update_checkpoint(m)
    mario_wrap_y_pos(m)
    mario_palette_swap(m)
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
