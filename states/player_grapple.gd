extends State
class_name PlayerGrapple

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	player.speed = 0
	player.angle = player.grapple_angle

func Physics_Update(_delta:float):
	player.circular_motion(_delta)
	
	if Input.is_action_just_pressed("move_right"):
		if player.grapple_speed < 0:
			player.grapple_speed *= -1
			
	if Input.is_action_just_pressed("move_left"):
		if player.grapple_speed >= 0:
			player.grapple_speed *= -1
	
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "PlayerMove")
