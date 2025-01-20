extends State
class_name PlayerGrapple

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D
@onready var charge_attack = preload("res://scenes/charge_attack.tscn")
@onready var attack_cd = %AttackCD

var grappling = false;

func Enter():
	player.angle = player.grapple_angle
	%GrappleTimer.start()

func Physics_Update(_delta:float):
	if grappling == true:
		%StateMachine.grappling = true
		player.speed = 0
		player.circular_motion(_delta)
		
		if Input.is_action_just_pressed("move_right"):
			if player.grapple_speed < 0:
				player.grapple_speed *= -1
				
		if Input.is_action_just_pressed("move_left"):
			if player.grapple_speed >= 0:
				player.grapple_speed *= -1
				
		if Input.is_action_just_pressed("lmb") and player.has_sickle:
			%StateMachine.grapple_attacking = true
			attack(player.target)
			player.has_sickle = false
		
		if Input.is_action_just_pressed("jump"):
			%StateMachine.grappling = false
			grappling = false
			Transitioned.emit(self, "PlayerMove")
	else:
		player.velocity.x = player.speed * player.direction
		if not player.is_on_floor():
			player.velocity.y += player.gravity * _delta

func attack(target):
	var b = charge_attack.instantiate()
	get_tree().get_first_node_in_group("projectile_node").add_child(b)
	b.change_target(target)
	b.transform = player.global_transform
	


func _on_grapple_timer_timeout() -> void:
	%StateMachine.charging = false
	grappling = true
