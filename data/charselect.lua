--this is a terrible way of fixing an issue i was having for my character mod, but im very much not very code knowledgy yet, sorry about that.
for i = 0, MAX_PLAYERS - 1 do
    local s = gPlayerSyncTable[i]
    s.playerDead = 0
    s.glow = 0
    s.glowDir = 0
    s.fixTimer = 0
end

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
                if s.Glow >= 60 then s.GlowDir = 1 end
            else
                s.Glow = (s.Glow or 0) - 2
                if s.Glow <= 0 then s.GlowDir = 0 end
            end
        end

        local glow = s.Glow

        if s.playerDead == 0 then
            --clamping needed here else it breaks because ???.
            local r = math.max(0, math.min(255, math.floor(defaultCap.r - (glow / 2) - (math.random() * 20))))
            local g = math.max(0, math.min(255, math.floor(defaultCap.g - (glow / 2))))
            local b = math.max(0, math.min(255, math.floor(defaultCap.b - glow)))

            network_player_set_override_palette_color(np, CAP, { r = r, g = g, b = b })
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, palette_but_romhack)
