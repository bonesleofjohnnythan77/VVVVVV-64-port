vec3f_set(gLevelValues.starPositions.KoopaBobStarPos, 3030, 4500, -4600)
vec3f_set(gLevelValues.starPositions.KoopaThiStarPos, 7100, -1300, -6000)


hook_event(HOOK_USE_ACT_SELECT, function(levelNum)
    if levelNum == LEVEL_BOB then
        return false
    end
end)

hook_event(HOOK_ON_MODS_LOADED, function()
    gServerSettings.stayInLevelAfterStar = false
    gServerSettings.bubbleDeath = 0
    gLevelValues.exitCastleLevel = LEVEL_CASTLE_GROUNDS
    gLevelValues.exitCastleArea = 1
    gLevelValues.exitCastleWarpNode = 10
    gServerSettings.playerInteractions = PLAYER_INTERACTIONS_NONE
end)
