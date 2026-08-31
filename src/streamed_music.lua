local streams = {}
local prevMusic = -1

function replace_sequence_streamed(seqId, soundFile, looping, loopStart, loopEnd)
    smlua_audio_utils_replace_sequence(seqId, 0, 75, "00_Seq_Custom") -- silence
    local stream = audio_stream_load(soundFile)

    if looping then
        audio_stream_set_looping(stream, true)

        if loopStart and loopEnd then
            audio_stream_set_loop_points(stream, loopStart, loopEnd)
        end
    end

    streams[seqId] = stream
end

local function streamed_music_update()
    local curMusic = get_current_background_music() & 0xFF

    if curMusic ~= prevMusic then
        local prevStream = streams[prevMusic]

        if prevStream then
            audio_stream_stop(prevStream)
        end

        local nextStream = streams[curMusic]

        if nextStream then
            audio_stream_play(nextStream, false, 1.0)
        end
    end

    local curStream = streams[curMusic]

    if curStream then
        local volume = 1.0

        local baseVolume = get_current_background_music_default_volume() / 127
        local fadeVolume = sequence_player_get_fade_volume(SEQ_PLAYER_LEVEL)

        volume = volume * get_volume_master() / 127
        volume = volume * fadeVolume / baseVolume

        if is_game_paused() then
            -- last impact doesn't have mute behaviors, volume always softens when paused
            -- volume = volume * sequence_player_get_mute_volume_scale(SEQ_PLAYER_LEVEL)
            volume = volume * 0.31
        end

        volume = math.clamp(volume, 0, 1)

        if volume == 0 then
            audio_stream_pause(curStream)
            return
        end

        audio_stream_set_volume(curStream, volume)
    end

    prevMusic = curMusic
end

hook_event(HOOK_UPDATE, streamed_music_update)