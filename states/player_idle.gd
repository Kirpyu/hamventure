extends State
class_name PlayerIdle

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	player.speed = 0
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func Physics_Update(_delta:float):
	animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("lmb"):
		Transitioned.emit(self, "PlayerAttack")
#	
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "PlayerJump")
		
	if player.direction != 0:
		Transitioned.emit(self, "PlayerMove")
	
	if not player.is_on_floor():
		Transitioned.emit(self, "PlayerMove")
