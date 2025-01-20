extends CharacterBody2D


@export var speed = 50
@export var grapple_speed = 3
const JUMP_VELOCITY = -150.0

@export var radius: float = 30
var angle : float = 0
var grappled = false
var direction = null;
@onready var anchor = %Anchor
var grapple_angle : float
var relative_vector : Vector2
var normalized_vector : Vector2 = Vector2(0,0)
@onready var state_machine = %StateMachine

var current_jump = 1
var jump_count = 2
var attack_hitboxes : Dictionary = {}
var has_sickle = true
# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#variables for animation
@onready var animated_sprite = $AnimatedSprite2D
@export var animation_tree: AnimationTree

func _ready() -> void:
	for hitbox in %AttackBox.get_children():
		attack_hitboxes[hitbox.name] = hitbox
		
func _physics_process(delta):
	print(angle)
	grapple_angle = atan2(global_position.y - anchor.global_position.y, global_position.x - anchor.global_position.x)
	direction = Input.get_axis("move_left","move_right")
	move_and_slide()

var attack_dir;
func attack(dir: String):
	if %ResetTimer.is_stopped():
		attack_dir = dir
		%StateMachine.attack(dir)
		if attack_hitboxes[dir]:
			attack_hitboxes[dir].set_deferred("disabled", false)
		else:
			attack_hitboxes["Right"].set_deferred("disabled", false)
		%ResetTimer.start()
		
func _on_reset_timer_timeout() -> void:
	attack_hitboxes[attack_dir].set_deferred("disabled", true)

func circular_motion(delta):
	angle += grapple_speed * delta
	
	var x_pos = cos(angle)
	var y_pos = sin(angle)

	position.x = radius * x_pos + anchor.global_position.x
	position.y = radius * y_pos + anchor.global_position.y
	
	relative_vector = position - anchor.global_position
	if abs(relative_vector.x) > abs(relative_vector.y):
		# Horizontal dominant
		normalized_vector = Vector2(sign(relative_vector.x), 0)
	else:
		# Vertical dominant
		normalized_vector = Vector2(0, sign(relative_vector.y))
