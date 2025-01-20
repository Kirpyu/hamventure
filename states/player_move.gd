extends State
class_name PlayerMove

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@export var jump_time : float = 0.1
var jump_timer = 0;
var dashed : bool = false;

@onready var attack_cd : Timer = %AttackCD
@onready var dash_cd : Timer = %DashCD

func Enter():
	player.speed = player.max_speed

func Update(_delta:float):
	jump_timer -= _delta
	
func Physics_Update(_delta:float):	
	player.velocity.x = player.speed * player.direction
	
	if Input.is_action_just_pressed("lmb") and attack_cd.is_stopped():
		attack_cd.start()
		Transitioned.emit(self, "PlayerAttack")
	
	if Input.is_action_just_pressed("shift"):
		if dash_cd.is_stopped() and !dashed:
			dashed = true;
			dash_cd.start()
			Transitioned.emit(self, "PlayerDash")
	
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor():
			player.current_jump = 1
			Transitioned.emit(self, "PlayerJump")
		elif player.current_jump < player.jump_count:
			player.current_jump += 1
			Transitioned.emit(self, "PlayerJump")
		else:
			jump_timer = jump_time
		
	if Input.is_action_just_released("jump"):
		if player.current_jump < player.jump_count:
			player.velocity.y *= 0.3
		
	if not player.is_on_floor():
		player.velocity.y += player.gravity * _delta
		
	if player.is_on_floor():
		if jump_timer > 0:
			Transitioned.emit(self, "PlayerJump")
		dashed = false;
