require "streamed_music"

-- smlua_audio_utils_replace_sequence(0x03, 0x22, 75, "03_Seq_custom")

-- replace_sequence_streamed(0x01, "01_Seq_custom.mp3", false)
replace_sequence_streamed(0x03, "03_Seq_custom.mp3", true)

smlua_audio_utils_replace_sequence(0x1A, 0x25, 75, "1A_Seq_custom")
smlua_audio_utils_replace_sequence(0x23, 0x19, 75, "23_Seq_custom")