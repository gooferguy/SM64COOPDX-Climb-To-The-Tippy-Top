-- name: Climb To The Tippy Top
-- description: This is a short mod that adds a challenging level.

local is_view_overridden = false

local function change_view(msg)
    msg = tonumber(msg)
    local camera = obj_get_first_with_behavior_id(id_bhvCameraLocation)

    for i = 1, obj_count_objects_with_behavior_id(id_bhvCameraLocation) do
        if camera.oBehParams2ndByte == msg then
                gLakituState.pos.x = camera.oPosX
                gLakituState.pos.y = camera.oPosY
                gLakituState.pos.z = camera.oPosZ
                gLakituState.focus.x = camera.oPosX + (20 * coss(-camera.oFaceAnglePitch) * sins(camera.oFaceAngleYaw))
                gLakituState.focus.z = camera.oPosZ + (20 * coss(-camera.oFaceAnglePitch) * coss(camera.oFaceAngleYaw))
                gLakituState.focus.y = camera.oPosY + (20 * sins(-camera.oFaceAnglePitch))
                gLakituState.yaw = camera.oFaceAngleYaw
                is_view_overridden = true
                camera_freeze()
            return true
        end
        camera = obj_get_next_with_same_behavior_id(camera)
    end
end

id_bhvCameraLocation = hook_behavior(nil, OBJ_LIST_GENACTOR, false, nil, nil, nil)

local function update()
    if is_view_overridden then
        set_override_fov(90)
    end
end

hook_event(HOOK_UPDATE, update)

if network_is_server() then
    hook_chat_command("changeview", "\\#00ffff\\[index]", change_view)
end