local function bhv_custom_star_init(o)
    o.oFlags = 0x0001
    bhv_collect_star_init()
end

local function bhv_custom_star_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x800;
    local m = gMarioStates[0]

    if obj_check_if_collided_with_object(o, m.marioObj) ~= 0 then
        interact_star_or_key(m, 0, o)
        obj_mark_for_deletion(o)
    end

    spawn_star_number()
end

bhvCustomStar = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_custom_star_init, bhv_custom_star_loop, "bhvCustomStar")

local function bhv_star_spawn_init(o)
    cur_obj_hide()

    spawn_non_sync_object(bhvCustomStar, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, function(star)
        star.oBehParams = o.oBehParams
        star.oBehParams2ndByte = o.oBehParams2ndByte
    end)
end

bhvStarSpawn = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_star_spawn_init, nil, "bhvStarSpawn")