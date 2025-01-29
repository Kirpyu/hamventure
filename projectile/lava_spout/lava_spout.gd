extends Projectile

var player : Player

func _ready() -> void:
	sprite.play("default")
	particles.emitting = true
	player = get_tree().get_first_node_in_group("player")
	global_position.y = 20
	global_position.x = player.global_position.x

func _on_cpu_particles_2d_finished() -> void:
	sprite.play("ending")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "ending":
		queue_free()
		
# Plan for tailslam and this : Create a warning box for 1,5 secs, so while timer is running
# then do everything in the ready part after timer runs out
# another is show warning sprite, then hide after timer finishes
