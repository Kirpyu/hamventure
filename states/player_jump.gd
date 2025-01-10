extends State
class_name PlayerJump

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@onready var attack_cd : Timer = %AttackCD

func Enter():
	player.speed = 100
	player.velocity.y = player.JUMP_VELOCITY
	
func Physics_Update(_delta:float):
	animated_sprite.play("jump")
	
	if player.direction > 0:
		animated_sprite.flip_h = false
	elif player.direction < 0:
		animated_sprite.flip_h = true
	else:
		Transitioned.emit(self, "PlayerIdle")
		
	player.velocity.x = player.speed * player.direction
		
	if Input.is_action_just_pressed("lmb") and attack_cd.is_stopped():
		attack_cd.start()
		Transitioned.emit(self, "PlayerAttack")
	
	if player.is_on_floor():
		Transitioned.emit(self, "PlayerMove")
	
	Transitioned.emit(self, "PlayerMove")
