extends State
class_name PlayerQuickAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Physics_Update(_delta:float):
	if Input.is_action_pressed("move_right"):
		player.attack("Right")
	elif Input.is_action_pressed("move_left"):
		player.attack("Left")
	elif Input.is_action_pressed("move_up"):
		player.attack("Up")
	elif Input.is_action_pressed("move_down"):
		player.attack("Down")
	else:
		if animated_sprite.flip_h == false:
			player.attack("Right")
		else:
			player.attack("Left")
	Transitioned.emit(self, "PlayerMove")
	
