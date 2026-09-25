--Original Code by PeachyPeach

local GFX_MAX_LENGTH      = 0x800
local GFX_PATCH_SIZE      = 5
local MAX_PATCHES_PER_GFX = GFX_MAX_LENGTH // GFX_PATCH_SIZE

local GRAPH_NODE_TYPE_DL  = {
    [GRAPH_NODE_TYPE_TRANSLATION_ROTATION] = true,
    [GRAPH_NODE_TYPE_TRANSLATION]          = true,
    [GRAPH_NODE_TYPE_ROTATION]             = true,
    [GRAPH_NODE_TYPE_ANIMATED_PART]        = true,
    [GRAPH_NODE_TYPE_BILLBOARD]            = true,
    [GRAPH_NODE_TYPE_DISPLAY_LIST]         = true,
    [GRAPH_NODE_TYPE_SCALE]                = true,
    [GRAPH_NODE_TYPE_SCALE_XYZ]            = true,
    [GRAPH_NODE_TYPE_BONE]                 = true,
}

local sGraphNodeToggle    = {}
local sGfxCache           = {}
local sGfxPatchIndex      = 0


local dl_make_player_red = gfx_create("dl_make_player_red", 3)
gfx_set_command(gfx_get_command(dl_make_player_red, 0),
    "gsDPSetCombineLERP(1, 0, ENVIRONMENT, 0, 0, 0, 0, ENVIRONMENT, 1, 0, ENVIRONMENT, 0, 0, 0, 0, ENVIRONMENT)")
gfx_set_command(gfx_get_command(dl_make_player_red, 1), "gsDPSetEnvColor(255, 0, 0, 255)")
gfx_set_command(gfx_get_command(dl_make_player_red, 2), "gsSPEndDisplayList()")



local function toggle_command(cmd, enable)
    if enable then
        gfx_set_command(cmd, "gsSPDisplayList(%g)", dl_make_player_red)
    else
        gfx_set_command(cmd, "gsDPPipeSync()")
    end
end

local function patch_display_list(cmd, enable)
    local index    = sGfxPatchIndex // MAX_PATCHES_PER_GFX
    local subIndex = sGfxPatchIndex % MAX_PATCHES_PER_GFX
    local name     = "toggle_red_lighting_color_gfx_" .. tostring(index)
    local gfx      = gfx_get_from_name(name)
    gfx            = gfx and gfx_get_command(gfx, subIndex * GFX_PATCH_SIZE) or gfx_create(name, GFX_MAX_LENGTH)

    gfx_set_command(gfx_get_command(gfx, 0), "gsSPSaveState(G_STATE_GEOMETRY_MODE)")
    toggle_command(gfx_get_command(gfx, 1), enable)
    gfx_copy(gfx_get_command(gfx, 2), cmd, 1)
    gfx_set_command(gfx_get_command(gfx, 3), "gsSPLoadState(G_STATE_GEOMETRY_MODE)")
    gfx_set_command(gfx_get_command(gfx, 4), "gsSPEndDisplayList()")

    sGfxPatchIndex = sGfxPatchIndex + 1
    sGfxCache[gfx] = true
    gfx_set_command(cmd, "gsSPDisplayList(%g)", gfx)
end

local function patch_graph_node(node, enable)
    local head = node
    repeat
        if GRAPH_NODE_TYPE_DL[head.type] then
            local displayList = cast_graph_node(head).displayList
            local skip = 0

            gfx_parse(displayList, function(cmd, op)
                if skip == 0 then
                    -- Patched
                    if sGfxCache[cmd] then
                        toggle_command(gfx_get_command(cmd, 1), enable)
                        skip = GFX_PATCH_SIZE - 2
                    end

                    -- Unpatched
                    if op == G_VTX or op == G_VTX_EXT then
                        patch_display_list(cmd, enable)
                    end
                else
                    skip = skip - 1
                end
            end)
        end

        if head.children then
            patch_graph_node(head.children, enable)
        end

        head = head.next
    until head == node
end


function set_player_lights_red(root, enable)
    local state = sGraphNodeToggle[root]
    if state ~= enable then
        patch_graph_node(root, enable)
        sGraphNodeToggle[root] = enable
    end
end

hook_event(HOOK_ON_OBJECT_RENDER, function(o)
    if o.hookRender == 1 then
        local m = get_mario_state_from_object(o)

        set_player_lights_red(o.header.gfx.sharedChild, (m.flags & MARIO_METAL_CAP) ~= 0)
    end
end)
