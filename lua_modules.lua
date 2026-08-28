--local sLevelInformation = {
    --[LEVEL_WF] = { { LEVEL_WF, 1, -1716, 1069, -11000, 20000, -32516, 32728 }, false, 0 },
--}
--[[
-- Disable OMM camera for 2D areas
if OmmApi then
    OmmApi.omm_register_game("VVVVVV 64", function () return true end, function ()
        OmmApi.omm_register_game_data(-1, 2, LEVEL_PSS, true, false, 0, 250, nil)
        for _, levelData in pairs(sLevelInformation) do
            OmmApi.omm_register_camera_no_collision_box(table.unpack(levelData[1]))
        end
    end)
end

--[[ Keep player on 2D axis
hook_event(HOOK_MARIO_UPDATE, function (m)
    if m.playerIndex ~= 0 then return end
    local np = gNetworkPlayers[m.playerIndex]
    local levelData = sLevelInformation[np.currLevelNum]
    if levelData and levelData[1][2] == np.currAreaIndex then
        if levelData[1] then
            m.pos.z = levelData[2]
        else
            m.pos.x = levelData[2]
        end
    end
end)
]]