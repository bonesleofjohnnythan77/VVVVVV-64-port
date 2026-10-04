local function hook_bhv_star_loop(o)
    if o.oUnkC0 == 0 then
        local behId = get_id_from_behavior(o.behavior)
        local model = obj_get_model_id_extended(o)

        local star = spawn_non_sync_object(behId, model, o.oPosX, o.oPosY, o.oPosZ, nil)

        star.oUnkC0 = 1
        o.oUnkC0 = 2
    end

    if o.oUnkC0 == 2 then
        cur_obj_hide()
        cur_obj_become_intangible()
    end
end
hook_behavior(id_bhvStar, OBJ_LIST_LEVEL, false, nil, hook_bhv_star_loop, "bhVVVVVVStar")