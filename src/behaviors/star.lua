local function hook_bhv_star_init(o)
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE

    bhv_init_room()
    bhv_collect_star_init()

    o.oAction = 0
    o.oIntangibleTimer = 0
    o.oInteractStatus = 0

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

    if o.oAction > 3 then
        o.oAction = 0
    end

    network_init_object(o, false, nil)
end

local function hook_bhv_star_spawn_loop(o)
    if o.oAction == 0 then
        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000

        if o.oTimer > 20 then
            o.oAction = 1
        end
    elseif o.oAction == 1 then
        obj_move_xyz_using_fvel_and_yaw(o)
        o.oStarSpawnUnkFC = o.oStarSpawnUnkFC + o.oVelY
        o.oPosY = o.oStarSpawnUnkFC + sins((o.oTimer * 0x8000) / 30) * 400.0
        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000

        spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ)
        cur_obj_play_sound_1(SOUND_ENV_STAR)

        if o.oTimer == 30 then
            o.oAction = 2
            o.oForwardVel = 0
            play_power_star_jingle(1)
        end
    elseif o.oAction == 2 then
        if o.oTimer < 20 then
            o.oVelY = 20 - o.oTimer
        else
            o.oVelY = -10.0
        end

        spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ)
        obj_move_xyz_using_fvel_and_yaw(o)
        o.oFaceAngleYaw = o.oFaceAngleYaw - o.oTimer * 0x10 + 0x1000
        cur_obj_play_sound_1(SOUND_ENV_STAR)

        if o.oPosY < o.oHomeY then
            cur_obj_play_sound_2(SOUND_GENERAL_STAR_APPEARS)
            cur_obj_become_tangible()
            o.oPosY = o.oHomeY
            o.oAction = 3
        end
    elseif o.oAction == 3 then
        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x800

        local m = gMarioStates[0]

        if o.oTimer == 20 then
            soft_reset_camera(m.area.camera)
            clear_time_stop_flags(TIME_STOP_ENABLED | TIME_STOP_MARIO_AND_DOORS)
            o.activeFlags = o.activeFlags & (~ACTIVE_FLAG_INITIATED_TIME_STOP)
        end

        o.oIntangibleTimer = 0
        o.oInteractStatus = 0

        if obj_check_if_collided_with_object(o, m.marioObj) ~= 0 then
            cur_obj_become_intangible()
            cur_obj_hide()

            o.oAction = 4
        end
    end
end

hook_behavior(id_bhvStarSpawnCoordinates, OBJ_LIST_LEVEL, true, hook_bhv_star_spawn_init, hook_bhv_star_spawn_loop, "bhvStarSpawnCoordinates")

local function hook_bhv_hidden_star_init(o)
    local count = count_objects_with_behavior(get_behavior_from_id(id_bhvHiddenStarTrigger))

    if count == 0 then
        spawn_non_sync_object(id_bhvStar, E_MODEL_STAR, o.oPosX, o.oPosY, o.oPosZ, function(star)
            star.oBehParams = o.oBehParams
        end)

        obj_mark_for_deletion(o)
    end

    o.oHiddenStarTriggerCounter = 5 - count

    network_init_object(o, false, {"oHiddenStarTriggerCounter"})
end

local function hook_bhv_hidden_star_loop(o)
    if o.oAction == 0 then
        if o.oHiddenStarTriggerCounter == 5 then
            o.oAction = 1
        end
    elseif o.oAction == 1 then
        if o.oTimer > 2 then

            if sync_object_is_owned_locally(o.oSyncID) then
                spawn_sync_object(id_bhvStarSpawnCoordinates, E_MODEL_STAR, o.oPosX, o.oPosY, o.oPosZ, function(star)
                    star.oBehParams = o.oBehParams
                    star.oBehParams2ndByte = 1

                    star.oHomeX = o.oPosX
                    star.oHomeX = o.oPosY
                    star.oHomeX = o.oPosZ

                    star.oFaceAnglePitch = 0
                    star.oFaceAngleRoll = 0

                    cutscene_object(CUTSCENE_RED_COIN_STAR_SPAWN, star)
                end)
            end

            spawn_mist_particles()
            obj_mark_for_deletion(o)
        end
    end
end

hook_behavior(id_bhvHiddenStar, OBJ_LIST_LEVEL, true, hook_bhv_hidden_star_init, hook_bhv_hidden_star_loop, "bhvHiddenStar")
