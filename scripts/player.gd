extends CharacterBody2D


@export var speed = 100
@export var grapple_speed = 5
const JUMP_VELOCITY = -300.0

@export var radius: float = 50
var angle : float = 0
var grappled = false
var direction = null;
@onready var initial_pos = %Anchor
var grapple_angle : float

var current_jump = 1
var jump_count = 2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	
	grapple_angle = atan2(global_position.y - initial_pos.global_position.y, global_position.x - initial_pos.global_position.x)
	direction = Input.get_axis("move_left","move_right")
	move_and_slide()

func circular_motion(delta):
	angle += grapple_speed * delta
	
	var x_pos = cos(angle)
	var y_pos = sin(angle)

	position.x = radius * x_pos + initial_pos.global_position.x
	position.y = radius * y_pos + initial_pos.global_position.y
