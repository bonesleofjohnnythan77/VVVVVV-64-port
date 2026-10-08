local p = gNetworkPlayers[0]
local fixcam = 0

local dist_values = {}
local height_values = {}

local levels = {
    -- add levels here
    [LEVEL_WF] = { -2,  true,  0 },
 -- [LEVEL_XP] = { fixcam, x? (boolean), magic value },
}

for i = 600, 1800, 50 do table.insert(dist_values, i) end
for i = 300, 640, 20 do table.insert(height_values, i) end

-- prevents players from using camera buttons (left/right) and stick up/down, unless in c-up mode
---@param m MarioState
function lockbuttons(m)
    local np = gNetworkPlayers[m.playerIndex]

    if levels[np.currLevelNum] == nil then return end
    if m.controller.buttonPressed & L_CBUTTONS ~= 0 then
        m.controller.buttonPressed = m.controller.buttonPressed - L_CBUTTONS
    end
    if m.controller.buttonPressed & R_CBUTTONS ~= 0 then
        m.controller.buttonPressed = m.controller.buttonPressed - R_CBUTTONS
    end


    
    if m.playerIndex ~= 0 then return end

    m.controller.buttonPressed = m.controller.buttonPressed & ~(D_CBUTTONS | U_CBUTTONS)


    if not camera_config_is_free_cam_enabled() then
    if (m.controller.buttonDown & D_CBUTTONS) ~= 0  then
        dist_count = math.min(dist_count + 1, #dist_values)
        height_count = math.min(height_count + 1, #height_values)
    elseif (m.controller.buttonDown & U_CBUTTONS) ~= 0 then
        dist_count = math.max(dist_count - 1, 1)
        height_count = math.max(height_count - 1, 1)
    end

    if fixcam > 0 then
        m.controller.buttonPressed = R_CBUTTONS
        fixcam = fixcam - 1
    elseif fixcam < 0 then
        m.controller.buttonPressed = L_CBUTTONS
        fixcam = fixcam + 1
    end

    if (m.controller.buttonPressed & R_TRIG) ~= 0 then
        reset_camera(m.area.camera)
        dist_count = 16
        height_count = 6
    end

    m.controller.stickY = 0
    if m.controller.stickX == 0 then m.controller.stickMag = 0 end

    end
    local zoom = dist_values[dist_count]
    local height = height_values[height_count]

    camera_romhack_set_zoomed_out_dist(zoom)
    camera_romhack_set_zoomed_in_dist(zoom)
    camera_romhack_set_zoomed_out_height(height)
    camera_romhack_set_zoomed_in_height(height)



end

function twodee(m)
    local np = gNetworkPlayers[m.playerIndex]
    if levels[np.currLevelNum] ~= nil then
        if levels[np.currLevelNum][2] then       -- if x is true,
            m.pos.x = levels[np.currLevelNum][3] -- lock x coordinate to the magic value
        else                                     -- if not,
            m.pos.z = levels[np.currLevelNum][3] -- lock z coordinate instead 
        end
    end
end

function levelinit()
    if levels[p.currLevelNum] ~= nil then
        fixcam = levels[p.currLevelNum][1]
        dist_count = 16
        height_count = 12
    end
end

-- cartain actions reset the camera, so let's fix the camera after they break it
function onaction(m, action)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex ~= 0 or levels[np.currLevelNum] == nil then return end
    if action == ACT_BUBBLED or m.action == ACT_BUBBLED or m.action == ACT_STAR_DANCE_NO_EXIT then
        fixcam = levels[np.currLevelNum][1]
    end
end

hook_event(HOOK_BEFORE_SET_MARIO_ACTION,onaction)
hook_event(HOOK_ON_LEVEL_INIT,levelinit)
hook_event(HOOK_BEFORE_MARIO_UPDATE, lockbuttons)
hook_event(HOOK_MARIO_UPDATE, twodee)