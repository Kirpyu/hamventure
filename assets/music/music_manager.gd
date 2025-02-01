extends Node

func init_sound(sound: AudioStreamPlayer2D):
	var rng = RandomNumberGenerator.new()
	var original_pitch = sound.pitch_scale
	sound.pitch_scale += randf_range(-0.15, 0.15)
	sound.play()
	await sound.finished
	sound.pitch_scale = original_pitch
