local marioStateEx = {}

for i = 0, MAX_PLAYERS - 1 do
    marioStateEx[i] = {
        dead = false,
    }
    local s = gPlayerSyncTable[i]
    s.glow = 0
    s.glowDir = 0
    s.fixTimer = 0
end

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

    if s.fixTimer ~= 0 then
        marioStateEx[m.playerIndex].dead = true
        network_player_set_override_palette_color(np, PANTS, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, SHIRT, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, GLOVES, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, SHOES, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, HAIR, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, SKIN, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, CAP, { r = 255, g = 0, b = 0 })
        network_player_set_override_palette_color(np, EMBLEM, { r = 255, g = 0, b = 0 })
    end

    if s.fixTimer == 1 and marioStateEx[m.playerIndex].dead then
        marioStateEx[m.playerIndex].dead = false
        --djui_chat_message_create("reset")
        network_player_reset_override_palette(np)
    end
end

--this is a terrible way of fixing an issue i was having for my character mod, sorry about that.
function palette_but_romhack(m)
    if not _G.charSelectExists then return end
    local np = gNetworkPlayers[m.playerIndex]
    local s  = gPlayerSyncTable[m.playerIndex]

    if np.connected and _G.charSelect.character_get_current_number(m.playerIndex) == CT_VIRIDIAN then
        local defaultCap = network_player_get_palette_color(np, CAP)
        if _G.charSelect.character_get_current_palette_number(m.playerIndex) ~= 0 then
            defaultCap = network_player_get_override_palette_color(np, CAP)
        end
        --case 1: glowing effect
        if m.playerIndex == 0 then
            if (s.GlowDir or 0) == 0 then
                s.Glow = (s.Glow or 0) + 2
                if s.Glow >= 62 then s.GlowDir = 1 end
            else
                s.Glow = (s.Glow or 0) - 2
                if s.Glow <= 0 then s.GlowDir = 0 end
            end
        end

        local glow = s.Glow

        if marioStateEx[m.playerIndex].dead == false then
            --clamping needed here else it breaks because ???.
            local r = math.max(0, math.min(255, math.floor(defaultCap.r - (glow / 2) - (math.random() * 20))))
            local g = math.max(0, math.min(255, math.floor(defaultCap.g - (glow / 2))))
            local b = math.max(0, math.min(255, math.floor(defaultCap.b - glow)))

            network_player_set_override_palette_color(np, CAP, { r = r, g = g, b = b })
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
    palette_but_romhack(m)
end


hook_event(HOOK_MARIO_UPDATE, mario_update)
