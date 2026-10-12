local function hook_bhv_star_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE

    bhv_init_room()
    bhv_collect_star_init()

    network_init_object(o, false, nil)
end

local function hook_bhv_star_loop(o)
    local m = gMarioStates[0]

    if obj_check_if_collided_with_object(o, m.marioObj) ~= 0 then
        cur_obj_become_intangible()
        cur_obj_hide()
        o.oAction = 999
    end

    o.oInteractStatus = 0
    bhv_collect_star_loop()

    o.activeFlags = 257
end

hook_behavior(id_bhvStar, OBJ_LIST_LEVEL, true, hook_bhv_star_init, hook_bhv_star_loop, "bhvStar")

local function hook_bhv_star_spawn_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE

    bhv_collect_star_init()
    bhv_star_spawn_init()

    network_init_object(o, false, nil)
end

local function hook_bhv_star_spawn_loop(o)
    local m = gMarioStates[0]

    if obj_check_if_collided_with_object(o, m.marioObj) ~= 0 then
        cur_obj_become_intangible()
        cur_obj_hide()
        o.oAction = 999
    end

    o.oInteractStatus = 0
    bhv_star_spawn_loop()

    o.activeFlags = 257
end

hook_behavior(id_bhvStarSpawnCoordinates, OBJ_LIST_LEVEL, true, hook_bhv_star_spawn_init, hook_bhv_star_spawn_loop, "bhvStarSpawnCoordinates")