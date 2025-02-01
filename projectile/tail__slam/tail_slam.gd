extends Projectile

var player : Player
@export var warning_box : Sprite2D
@export var exclamation_mark : AnimatedSprite2D
@export var sfx : AudioStreamPlayer2D

@export var flip : bool = false
func _ready() -> void:
	hitbox.set_deferred("disabled", true)
	exclamation_mark.play("default")
	
	player = get_tree().get_first_node_in_group("player")
	var screen_size = get_viewport_rect().size
	global_position.y = 95
	if !flip:
		pass
		global_position.x = player.get_global_position().x - screen_size.x/3 + 10
	else:
		global_position.x = player.get_global_position().x + screen_size.x/3
		sprite.flip_h = true
		sprite.offset.x = -600
		warning_box.flip_h = true
		warning_box.offset.x = -1.2
		exclamation_mark.offset.x = -78
		hitbox.position.x -= 485
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func slam():
	hitbox.set_deferred("disabled", false)
	sprite.show()
	MusicManager.init_sound(sfx)
	sprite.play("default")
	particles.emitting = true
	
func _on_timer_timeout() -> void:
	warning_box.hide()
	slam()
