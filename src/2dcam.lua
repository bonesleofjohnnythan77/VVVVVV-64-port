--[[
-- the mod assumes that your levels are using the 8-direction camera

local p = gNetworkPlayers[0]
local fixcam = 0
local levels = {
    -- add levels here
    [LEVEL_WF] = { -2, true, 0 },
}

-- prevents players from using camera buttons (left/right) and stick up/down, unless in c-up mode
---@param m MarioState
function lockbuttons(m)
    local np = gNetworkPlayers[m.playerIndex]
    if levels[np.currLevelNum] == nil or gLakituState.mode == CAMERA_MODE_C_UP then return end
    if m.controller.buttonPressed & L_CBUTTONS ~= 0 then
        m.controller.buttonPressed = m.controller.buttonPressed - L_CBUTTONS
    end
    if m.controller.buttonPressed & R_CBUTTONS ~= 0 then
        m.controller.buttonPressed = m.controller.buttonPressed - R_CBUTTONS
    end
    
    if (m.controller.buttonPressed & R_TRIG) ~= 0 and not camera_config_is_free_cam_enabled() or (m.controller.buttonPressed & D_CBUTTONS) ~= 0 and gLakituState.mode == CAMERA_MODE_C_UP  then
        reset_camera(m.area.camera)
    end


    if m.playerIndex ~= 0 then return end

    if fixcam > 0 then
        m.controller.buttonPressed = R_CBUTTONS
        fixcam = fixcam - 1
    elseif fixcam < 0 then
        m.controller.buttonPressed = L_CBUTTONS
        fixcam = fixcam + 1
    end
    m.controller.stickY = 0
    if m.controller.stickX == 0 then m.controller.stickMag = 0 end
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

hook_event(HOOK_BEFORE_SET_MARIO_ACTION, onaction)
hook_event(HOOK_ON_LEVEL_INIT, levelinit)
hook_event(HOOK_BEFORE_MARIO_UPDATE, lockbuttons)
hook_event(HOOK_MARIO_UPDATE, twodee)
]]--


---@param focus Vec3f Focus of the camera.
---@param pos Vec3f Position of the camera.
local function set_camera_focus_and_pos(focus, pos)
    local l = gLakituState
    local m = gMarioStates[0]
    vec3f_set(l.goalFocus, focus.x, focus.y, focus.z)
    vec3f_set(l.goalPos, pos.x, pos.y, pos.z)

    if m.area.camera then
        m.area.camera.yaw = calculate_yaw(l.goalPos, l.goalFocus) - 32768
        vec3f_set(m.area.camera.pos, pos.x, pos.y, pos.z)
    end
end




function twodee_cam()
    local camActivated = false
    local np = gNetworkPlayers[0]
    local l = gLakituState
    local m = gMarioStates[0]

    if np.currLevelNum == LEVEL_WF then
        camActivated = true
    else
        camActivated = false
    end

    if (m.controller.buttonPressed & R_TRIG) ~= 0 and not camera_config_is_free_cam_enabled() or (m.controller.buttonPressed & D_CBUTTONS) ~= 0 and gLakituState.mode == CAMERA_MODE_C_UP  then
        reset_camera(m.area.camera)
    end

    

    if camActivated then
        l.mode = CAMERA_MODE_NONE
        m.pos.x = 0
        set_camera_focus_and_pos({ x = m.statusForCamera.pos.x, y = m.statusForCamera.pos.y + 250, z = m.statusForCamera.pos.z },
            { x = m.pos.x + 1000, y = m.statusForCamera.pos.y + 650, z = m.statusForCamera.pos.z })
    end
end

hook_event(HOOK_UPDATE, twodee_cam)
