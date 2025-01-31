extends Area2D

@onready var player : Player = %Player;
@export var fireball : PackedScene
@export var flip : bool
@export var sprite : Sprite2D
@export var max_hp : int = 100
var hp = max_hp
@export var hp_bar : HPBar
func _ready() -> void:
	if flip:
		sprite.flip_h = true
	%Target.player = player
	hp_bar.update_max_value(max_hp)

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

func take_damage(dmg:int):
	hp -= dmg
	hp_bar.update_hp_bar(dmg)
	
