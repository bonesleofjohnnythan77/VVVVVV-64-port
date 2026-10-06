-- 2D Camera --
local cam_fix_timer = 0

local dist_values = {}
local height_values = {}

for i = 600, 5000, 50 do table.insert(dist_values, i) end
for i = 100, 1500, 20 do table.insert(height_values, i) end

local levels = {
    [LEVEL_WF]  = { 0,  true,  0 },
--  [LEVEL_###] = { -, x, pos },
}

---@param m MarioState
local function buttonbhv(m)

    local np = gNetworkPlayers[m.playerIndex]

    if m.playerIndex ~= 0 or levels[np.currLevelNum] == nil then return end

    if (m.controller.buttonPressed & R_TRIG) ~= 0 then
        reset_camera(m.area.camera)
        dist_count = 16
        height_count = 16
    end

    m.controller.buttonPressed = m.controller.buttonPressed & ~(D_CBUTTONS | U_CBUTTONS | R_CBUTTONS | L_CBUTTONS)

    if (m.controller.buttonDown & D_CBUTTONS) ~= 0 then
        dist_count = math.min(dist_count + 1, #dist_values)
        height_count = math.min(height_count + 1, #height_values)
    elseif (m.controller.buttonDown & U_CBUTTONS) ~= 0 then
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

    if (m.controller.buttonPressed & R_CBUTTONS) ~= 0 then
        if cam_fix_timer == 0 and level_data and fixcam < (level_data[1] + 1) then
            fixcam = fixcam + 1
        else
            m.controller.buttonPressed = m.controller.buttonPressed & ~R_CBUTTONS
        end
    end

    if (m.controller.buttonPressed & L_CBUTTONS) ~= 0 then
        if cam_fix_timer == 0 and level_data and fixcam > (level_data[1] - 1) then
            fixcam = fixcam - 1
        else
            m.controller.buttonPressed = m.controller.buttonPressed & ~L_CBUTTONS
        end
    end
     
end


function movement()
    local m = gMarioStates[0]
    local np = gNetworkPlayers[m.playerIndex]
    local level_data = levels[np.currLevelNum]

    if level_data ~= nil then
        if level_data[2] then
            m.pos.x = level_data[3]
            m.vel.x = level_data[3]
        else
            m.pos.z = level_data[3]
            m.vel.z = level_data[3]
        end
    end

    if m.playerIndex ~= 0 then return end

    if cam_fix_timer > 0 then
        cam_fix_timer = cam_fix_timer - 1
        if cam_fix_timer == 0 then
            local level_data = levels[gNetworkPlayers[0].currLevelNum]
            if level_data then
                fixcam = level_data[1]
            end
        end
    end
   
end

function levelinit()
    local np = gNetworkPlayers[0]
    local level_data = levels[np.currLevelNum]
    if level_data ~= nil then
        dist_count = 16
        height_count = 16
        cam_fix_timer = 5
        fixcam = level_data[1]
        gMarioStates[0].controller.buttonPressed = D_CBUTTONS
    elseif not level_data then
        camera_romhack_set_zoomed_in_dist(900)
        camera_romhack_set_zoomed_out_dist(1400)
        camera_romhack_set_zoomed_in_height(300)
        camera_romhack_set_zoomed_out_height(450)
    end
end

---@param m MarioState
function actionfix(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex ~= 0 or levels[np.currLevelNum] == nil then return end

    if m.prevAction == ACT_READING_AUTOMATIC_DIALOG then
        cam_fix_timer = 20
    elseif m.prevAction == ACT_STAR_DANCE_NO_EXIT
        or m.prevAction == ACT_STAR_DANCE_WATER then
        cam_fix_timer = 20
    end

    if m.action == ACT_BUBBLED  then
        set_camera_mode(m.area.camera, CAMERA_MODE_8_DIRECTIONS, 1)
    end
end

hook_event(HOOK_ON_SET_MARIO_ACTION, actionfix)
hook_event(HOOK_ON_LEVEL_INIT, levelinit)
hook_event(HOOK_BEFORE_MARIO_UPDATE, buttonbhv)
hook_event(HOOK_BEFORE_PHYS_STEP, movement)
