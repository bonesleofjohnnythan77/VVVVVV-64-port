local function bhv_star_init(o)
    local behId = get_id_from_behavior(o.behavior)
    local model = obj_get_model_id_extended(o)
    spawn_non_sync_object(behId, model, o.oPosX, o.oPosY, o.oPosZ, nil)
    o.oFlags = OBJ_FLAG_PERSISTENT_RESPAWN
    obj_mark_for_deletion(o)
end

hook_behavior(id_bhvStar, OBJ_LIST_GENACTOR, false, bhv_star_init, nil, "bhVVVVVVStar")