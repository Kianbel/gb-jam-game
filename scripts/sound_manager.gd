extends Node

func play_sound(stream: AudioStream, pitch_min: float, pitch_max: float, db: float = 1.0):
	if stream == null:
		return

	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = stream
	audio_player.pitch_scale = randf_range(pitch_min, pitch_max)
	audio_player.volume_db = db
	audio_player.max_polyphony = 0
	
	audio_player.finished.connect(audio_player.queue_free)
	
	add_child(audio_player)
	audio_player.play()
	
	return audio_player
