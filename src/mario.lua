local deathSound = audio_stream_load("sound/sound_death.mp3")

local redPalette = {
    palette = {
        [PANTS] = {r = 255, g = 0, b = 0},
        [SHIRT] = {r = 255, g = 0, b = 0},
        [CAP] = {r = 255, g = 0, b = 0},
        [SKIN] = {r = 255, g = 0, b = 0},
        [HAIR] = {r = 255, g = 0, b = 0},
        [GLOVES] = {r = 255, g = 0, b = 0},
        [SHOES] = {r = 255, g = 0, b = 0},
        [EMBLEM] = {r = 255, g = 0, b = 0},
    }
}


local function set_player_palette(m, palette)
    if not palette then
        return
    end

    local np = gNetworkPlayers[m.playerIndex]

    for part, color in pairs(palette) do
        if color then
            network_player_set_override_palette_color(np, part, color)
        end
    end
end

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

    local np = gNetworkPlayers[m.playerIndex]

    if gCheckpointTimer ~= 0 then
        if gCheckpointTimer == 1 then
            vec3f_copy(m.pos, gCheckpointPos)
            network_player_reset_override_palette(np)
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

    if (m.flags & MARIO_METAL_CAP) ~= 0 then
        for i = 0, PLAYER_PART_MAX - 1 do
            network_player_set_override_palette_color(np, i, {r = 255, g = 0, b = 0})
        end
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
    m.marioObj.hookRender = 1
    mario_check_death(m)
    mario_update_checkpoint(m)
    mario_wrap_y_pos(m)

end

hook_event(HOOK_MARIO_UPDATE, mario_update)
