extends State
class_name PlayerDash

@export var animated_sprite : AnimatedSprite2D
@export var player : CharacterBody2D

@export var dist : float = 0.1
var time_passed = 0
var prev_speed;

func Enter():
	prev_speed = player.speed
	player.speed = 600
	time_passed = 0
#	invulnerable = true
func Exit():
	player.speed = prev_speed 
#	invulnerable =  false
	
func Update(_delta):
	time_passed += _delta
	
func Physics_Update(_delta:float):
	player.velocity.x = player.speed * player.direction
	player.velocity.y = 0
	if time_passed >= dist:
		Transitioned.emit(self, "PlayerMove")
	
