extends State
class_name PlayerChargeAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@export var max_dist_to_target = 150
@onready var charge_attack = preload("res://scenes/charge_attack.tscn")

func Physics_Update(_delta:float):
	if player.global_position.distance_to(player.target.global_position) <= max_dist_to_target:
		Transitioned.emit(self, "PlayerGrapple")
		player.has_sickle = false
		attack(player.target)
	else:
		
		Transitioned.emit(self, "PlayerMove")
		
func attack(new_target):
	var b = charge_attack.instantiate()
	get_tree().get_first_node_in_group("projectile_node").add_child(b)
	b.change_target(new_target)
	b.transform = player.global_transform
	
	
	
