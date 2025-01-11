extends State
class_name PlayerChargeAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@export var max_dist_to_anchor = 150
func Physics_Update(_delta:float):
	if player.global_position.distance_to(player.anchor.global_position) <= max_dist_to_anchor:
		Transitioned.emit(self, "PlayerGrapple")
	else:
		print("Fail")
		Transitioned.emit(self, "PlayerMove")
