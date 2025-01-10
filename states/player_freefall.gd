extends State
class_name PlayerFreefall

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	player.speed = 100
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func Physics_Update(_delta:float):
	animated_sprite.play("run")
