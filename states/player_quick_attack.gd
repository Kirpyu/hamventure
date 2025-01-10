extends State
class_name PlayerQuickAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	print("Quick Attack")
	
func Physics_Update(_delta:float):
	Transitioned.emit(self, "PlayerMove")
	
