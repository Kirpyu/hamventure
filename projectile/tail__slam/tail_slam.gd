extends Projectile

var player : Player
@export var flip : bool = false
func _ready() -> void:
	sprite.play("default")
	player = get_tree().get_first_node_in_group("player")
	var screen_size = get_viewport_rect().size
	global_position.y = 95
	if !flip:
		global_position.x = player.get_global_position().x - screen_size.x/3 + 10
	else:
		global_position.x = player.get_global_position().x + screen_size.x/3
		sprite.flip_h = true
		sprite.offset.x = -600
		


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
