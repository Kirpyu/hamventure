extends Area2D

@onready var player : Player = %Player;
@export var fireball : PackedScene
@export var flip : bool
@export var sprite : Sprite2D

func _ready() -> void:
	if flip:
		sprite.flip_h = true
	%Target.player = player

func _on_shoot_timer_timeout() -> void:
	fire_projectile()

func fire_projectile():
	var b = fireball.instantiate()
	if b is Projectile:
		var direction = look_at_player()
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
		b.transform = %Target.global_transform
		b.look_at(player.global_position)
		b.direction = look_at_player()

func look_at_player() -> Vector2:
	return (player.global_position - %Target.global_position).normalized()
