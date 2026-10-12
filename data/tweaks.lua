vec3f_set(gLevelValues.starPositions.KoopaBobStarPos, 3030, 4500, -4600)
vec3f_set(gLevelValues.starPositions.KoopaThiStarPos, 7100, -1300, -6000)


hook_event(HOOK_USE_ACT_SELECT, function(levelNum)
    if levelNum == LEVEL_BOB then
        return false
    end
end)


