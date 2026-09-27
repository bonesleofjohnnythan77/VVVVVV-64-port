


function override_palette(m)
    if not _G.charSelectExists then return end
    local np = gNetworkPlayers[m.playerIndex]
    if not np or not np.connected then return end


    local currentPal  = _G.charSelect.character_get_current_palette_number(m.playerIndex)


    if currentPal then
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            network_player_set_override_palette_color(np, CAP, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, PANTS, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, SHIRT, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, GLOVES, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, SHOES, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, HAIR, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, SKIN, { r = 255, g = 0, b = 0 })
            network_player_set_override_palette_color(np, EMBLEM, { r = 255, g = 0, b = 0 })
        else
            network_player_reset_override_palette(np)
        end

    end
end

hook_event(HOOK_MARIO_UPDATE, override_palette)
