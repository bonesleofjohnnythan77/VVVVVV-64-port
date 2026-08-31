-- 2D Camera --

local cam_fix_timer = 0
local cam_fix_button_press = 0

local dist_values = {}
local height_values = {}

for i = 600, 1800, 50 do table.insert(dist_values, i) end
for i = 300, 640, 20 do table.insert(height_values, i) end

local levels = {
    [LEVEL_WF] = { 0,  true, 0, true},
--  [LEVEL_###] = { -, x, pos, 2.5D },
}

---@param m MarioState
local function buttonbhv(m)

    local np = gNetworkPlayers[m.playerIndex]

    if m.playerIndex ~= 0 or levels[np.currLevelNum] == nil then return end

    if (m.controller.buttonPressed & R_TRIG) ~= 0 and not camera_config_is_free_cam_enabled() then
        reset_camera(m.area.camera)
        dist_count = 16
        height_count = 6
    end

    m.controller.buttonPressed = m.controller.buttonPressed & ~(D_CBUTTONS | U_CBUTTONS)

    if (m.controller.buttonDown & D_CBUTTONS) ~= 0  and not camera_config_is_free_cam_enabled() then
        dist_count = math.min(dist_count + 1, #dist_values)
        height_count = math.min(height_count + 1, #height_values)
    elseif (m.controller.buttonDown & U_CBUTTONS) ~= 0 and not camera_config_is_free_cam_enabled() then
        dist_count = math.max(dist_count - 1, 1)
        height_count = math.max(height_count - 1, 1)
    end

    local zoom = dist_values[dist_count]
    local height = height_values[height_count]

    camera_romhack_set_zoomed_out_dist(zoom)
    camera_romhack_set_zoomed_in_dist(zoom)
    camera_romhack_set_zoomed_out_height(height)
    camera_romhack_set_zoomed_in_height(height)

    local level_data = levels[np.currLevelNum]

    if level_data and level_data[4] and not camera_config_is_free_cam_enabled() then
        if (m.controller.buttonPressed & R_CBUTTONS) ~= 0 then
            if cam_fix_timer == 0 and fixcam < (level_data[1] + 1) then
                fixcam = fixcam + 1
            else
                m.controller.buttonPressed = m.controller.buttonPressed & ~R_CBUTTONS
            end
        end

        if (m.controller.buttonPressed & L_CBUTTONS) ~= 0 and not camera_config_is_free_cam_enabled() then
            if cam_fix_timer == 0 and fixcam > (level_data[1] - 1) then
                fixcam = fixcam - 1
            else
                m.controller.buttonPressed = m.controller.buttonPressed & ~L_CBUTTONS
            end
        end
    else
        m.controller.buttonPressed = m.controller.buttonPressed & ~(R_CBUTTONS | L_CBUTTONS)
    end
end

---@param m MarioState
function movement(m)
    local np = gNetworkPlayers[m.playerIndex]
    local level_data = levels[np.currLevelNum]

    if level_data ~= nil then
        if (m.action == ACT_STAR_DANCE_NO_EXIT and m.actionTimer == 55)
            or (m.action == ACT_STAR_DANCE_WATER and m.actionArg == 1 and m.actionTimer == 79) then
        m.actionState = 2
    end
        if level_data[2] then
            m.pos.x = level_data[3]
        else
            m.pos.z = level_data[3]
        end
    end

    if m.playerIndex ~= 0 then return end

    if cam_fix_timer > 0 and not camera_config_is_free_cam_enabled()  then
        cam_fix_timer = cam_fix_timer - 1
        if cam_fix_timer == 0 then
            local level_data = levels[gNetworkPlayers[0].currLevelNum]
            if level_data then
                fixcam = level_data[1] - level_data[1]
                gLakituState.mode = CAMERA_MODE_8_DIRECTIONS
                cam_fix_button_press = 2
            end
        end
    end

    if cam_fix_button_press > 0 then
        m.controller.buttonPressed = m.controller.buttonPressed | R_CBUTTONS
        cam_fix_button_press = cam_fix_button_press - 1
    end
end

function levelinit()
    local np = gNetworkPlayers[0]
    local level_data = levels[np.currLevelNum]
    if level_data ~= nil then
        camera_romhack_allow_only_mods(1)
        camera_romhack_allow_dpad_usage(0)
        camera_romhack_allow_centering(0)
        camera_set_romhack_override(RCO_ALL)
        --camera_config_enable_free_cam(false)
        dist_count = 16
        height_count = 12
        cam_fix_timer = 5
        fixcam = level_data[1] - level_data[1]
    elseif not level_data then
        camera_romhack_allow_only_mods(0)
        camera_romhack_set_zoomed_in_dist(900)
        camera_romhack_set_zoomed_out_dist(1400)
        camera_romhack_set_zoomed_in_height(300)
        camera_romhack_set_zoomed_out_height(450)
    end
end

---@param m MarioState
function actionfix(m)
    local np = gNetworkPlayers[m.playerIndex]
    local level_data = levels[np.currLevelNum]
    if m.playerIndex ~= 0 or levels[np.currLevelNum] == nil then return end

    if level_data[4] then
        if m.action == ACT_READING_AUTOMATIC_DIALOG then
            cam_fix_timer = 20
        elseif m.prevAction == ACT_STAR_DANCE_NO_EXIT
            or (m.prevAction == ACT_STAR_DANCE_WATER and m.actionArg == 1) then
            cam_fix_timer = 20
        end
    end

    if m.action == ACT_BUBBLED  then
        set_camera_mode(m.area.camera, CAMERA_MODE_8_DIRECTIONS, 1)
    end
end

hook_event(HOOK_ON_SET_MARIO_ACTION, actionfix)
hook_event(HOOK_ON_LEVEL_INIT, levelinit)
hook_event(HOOK_BEFORE_MARIO_UPDATE, buttonbhv)
hook_event(HOOK_MARIO_UPDATE, movement)