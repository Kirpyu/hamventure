extends CharacterBody2D


@export var speed = 100
@export var grapple_speed = 0
const JUMP_VELOCITY = -300.0

@export var radius: float = 50
var angle : float = 0
var grappled = false
@onready var initial_pos = %Anchor
var grapple_angle : float


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	
	grapple_angle = atan2(global_position.y - initial_pos.global_position.y, global_position.x - initial_pos.global_position.x)
	if Input.is_action_pressed("lmb"):
		#if !grappled:
			#initial_pos = global_position
		if !grappled:
			angle = grapple_angle
		circular_motion(delta)
		grappled = true
	
	if Input.is_action_just_released("lmb"):
		grappled = false
		
	# Add the gravity.
	if not is_on_floor() and not grappled:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func circular_motion(delta):
	angle += grapple_speed * delta
	
	var x_pos = cos(angle)
	var y_pos = sin(angle)
	
	#position.x = radius * x_pos + initial_pos.x
	#position.y = radius * y_pos + initial_pos.y
	
	position.x = radius * x_pos + initial_pos.global_position.x
	position.y = radius * y_pos + initial_pos.global_position.y
	
