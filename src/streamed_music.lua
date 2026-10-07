gStreamedMusic = {}

-- music that's currently played, indexed by sequence player
local playingMusic = {}

function replace_sequence_streamed(seqId, soundFile, looping, loopStart, loopEnd)
    local stream = audio_stream_load(soundFile)
    if stream then
        audio_stream_set_looping(stream, looping)

        if loopStart and loopEnd then
            audio_stream_set_loop_points(stream, loopStart, loopEnd)
        end

        gStreamedMusic[seqId] = stream
    end
end

local function on_seq_load(player, seqId)
    local music = gStreamedMusic[seqId]
    local prevMusic = playingMusic[player]

    if prevMusic then
        audio_stream_stop(prevMusic)
    end

    if music then
        djui_chat_message_create("play " .. player .. " " .. seqId)
        audio_stream_play(music, false, 1.0)

        playingMusic[player] = music
        return 0
    end
end

local function streamed_music_update()
    for player, stream in pairs(playingMusic) do
        if stream then
            local volume = 1.0

            local baseVolume = 75 / 127 -- can't get default volume
            local fadeVolume = sequence_player_get_fade_volume(player)

            volume = volume * get_volume_master() / 127
            --volume = volume * sequence_player_get_volume(player)
            volume = volume * fadeVolume / baseVolume

            if is_game_paused() then
                -- last impact doesn't have mute behaviors, volume always softens when paused
                -- volume = volume * sequence_player_get_mute_volume_scale(SEQ_PLAYER_LEVEL)
                volume = volume * 0.31
            end

            volume = math.clamp(volume, 0, 1)

            if volume == 0 then
                audio_stream_pause(stream)
                return
            end

            audio_stream_set_volume(stream, volume)
        end
    end
end

hook_event(HOOK_UPDATE, streamed_music_update)
hook_event(HOOK_ON_SEQ_LOAD, on_seq_load)
