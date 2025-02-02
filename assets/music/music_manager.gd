extends Node

var sound_effects : Dictionary
func _ready() -> void:
	for sfx : AudioStreamPlayer2D in get_tree().get_nodes_in_group("sfx"):
		sound_effects[sfx.name] = sfx
		
func init_sound(sound: AudioStreamPlayer2D):
	var rng = RandomNumberGenerator.new()
	if not sound.has_meta("original_pitch"):
		sound.set_meta("original_pitch", sound.pitch_scale)
	
	# Get the original pitch from the meta data
	var original_pitch = sound.get_meta("original_pitch")
	sound.pitch_scale =  original_pitch + randf_range(-0.15, 0.15)
	sound.play()
	await sound.finished
	sound.pitch_scale = original_pitch

	
func play_hit():
	init_sound(sound_effects["HitSound"])
