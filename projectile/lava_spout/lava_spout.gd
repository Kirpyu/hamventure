extends Projectile

var player : Player
@export var warning_box : Sprite2D
@export var exclamation_mark : AnimatedSprite2D

func _ready() -> void:
	hitbox.set_deferred("disabled", true)
	exclamation_mark.play("default")
	
	player = get_tree().get_first_node_in_group("player")
	global_position.y = 20
	global_position.x = player.global_position.x

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
	
func _on_cpu_particles_2d_finished() -> void:
	sprite.play("ending")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "ending":
		queue_free()

func _on_eruption_timer_timeout() -> void:
	warning_box.hide()
	spout()

func spout() -> void:
	hitbox.set_deferred("disabled", false)
	sprite.show()
	sprite.play("default")
	particles.emitting = true
	
