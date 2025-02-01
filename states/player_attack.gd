extends State
class_name PlayerAttack

@export var animated_sprite : AnimatedSprite2D
@export var player : Player
@export var jump_time : float = 0.1
var jump_timer = 0;

@export var charge_timer : float = 0.1
var current_charge : float = 0

func Enter():
	player.get_closest_target()
	player.speed = player.max_speed * .75
	current_charge = 0
	%StateMachine.charging = true

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
		%StateMachine.charging = false
		
	player.velocity.x = player.speed * player.direction
	
	if not player.is_on_floor():
		player.velocity.y += player.gravity * 0.2 * _delta
	

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
