extends State
class_name PlayerMove

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

func Enter():
	player.speed = 100
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func Physics_Update(_delta:float):
	if player.is_on_floor():
		animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if player.direction > 0:
		animated_sprite.flip_h = false
	elif player.direction < 0:
		animated_sprite.flip_h = true
	elif player.is_on_floor():
		Transitioned.emit(self, "PlayerIdle")
		
	player.velocity.x = player.speed * player.direction
	
	if Input.is_action_just_pressed("lmb"):
		Transitioned.emit(self, "PlayerAttack")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
		
	if not player.is_on_floor():
		player.velocity.y += player.gravity * _delta
