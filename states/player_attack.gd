extends State
class_name PlayerAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@export var jump_time : float = 0.1
var jump_timer = 0;

@export var charge_timer : float = 0.3
var current_charge : float = 0

func Enter():
	player.speed = 100
	current_charge = 0

func Update(_delta:float):
	jump_timer -= _delta
	
	if Input.is_action_pressed("lmb"):
		current_charge += _delta
	
func Physics_Update(_delta:float):
	if Input.is_action_just_released("lmb"):
		if current_charge >= charge_timer:
			Transitioned.emit(self, "PlayerChargeAttack")
		else:
			Transitioned.emit(self, "PlayerQuickAttack")
		
	player.velocity.x = player.speed * player.direction
	
	if not player.is_on_floor():
		player.velocity.y += player.gravity * _delta
	

	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor():
			player.current_jump = 1
			player.velocity.y = player.JUMP_VELOCITY
		elif player.current_jump < player.jump_count:
			player.current_jump += 1
			player.velocity.y = player.JUMP_VELOCITY
		else:
			jump_timer = jump_time
		
	if Input.is_action_just_released("jump"):
		player.velocity.y *= 0.3
