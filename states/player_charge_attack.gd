extends State
class_name PlayerChargeAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	print("Charge Attack")
	
func Physics_Update(_delta:float):
	Transitioned.emit(self, "PlayerGrapple")
