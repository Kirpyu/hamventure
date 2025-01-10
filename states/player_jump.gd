extends State
class_name PlayerJump

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@export var max_height : float = 0.5 #how long he can jump
var current_height : float = 0

func Enter():
	player.speed = 100
	player.velocity.y = player.JUMP_VELOCITY
	
func Physics_Update(_delta:float):
	if player.is_on_floor():
		animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if player.direction > 0:
		animated_sprite.flip_h = false
	elif player.direction < 0:
		animated_sprite.flip_h = true
	else:
		Transitioned.emit(self, "PlayerIdle")
		
	player.velocity.x = player.speed * player.direction
	
	if Input.is_action_just_pressed("lmb"):
		Transitioned.emit(self, "PlayerAttack")
		
	#current_height += _delta
	#
	#if Input.is_action_pressed("jump"):
		#max_height += _delta
		#
	#if Input.is_action_just_released("jump"):
		#Transitioned.emit(self, "PlayerMove")
	
	Transitioned.emit(self, "PlayerMove")
