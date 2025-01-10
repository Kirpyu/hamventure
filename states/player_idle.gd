extends State
class_name PlayerIdle

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@onready var attack_cd : Timer = %AttackCD

func Enter():
	player.speed = 0
	
func Physics_Update(_delta:float):
	animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("lmb") and attack_cd.is_stopped():
		attack_cd.start()
		Transitioned.emit(self, "PlayerAttack")
#	
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor():
			player.current_jump = 1
			Transitioned.emit(self, "PlayerJump")
		elif player.current_jump < player.jump_count:
			player.current_jump += 1
			Transitioned.emit(self, "PlayerJump")
		
	if player.direction != 0:
		Transitioned.emit(self, "PlayerMove")
	
	if not player.is_on_floor() and not Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "PlayerMove")
