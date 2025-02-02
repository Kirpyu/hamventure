extends CharacterBody2D
class_name Player

@export var pause_screen : PauseScreen
@export var invulnerable : bool
@export var speed = 200
@export var max_hp = 150
var current_hp = max_hp

const max_speed = 200
@export var grapple_speed = 5
const JUMP_VELOCITY = -300.0

@export var grapple_amount: float = 30
var angle : float = 0
var grappled : bool = false
var direction = null;
@onready var target : Target
var grapple_angle : float
var relative_vector : Vector2
var normalized_vector : Vector2 = Vector2(0,0)
var normalized_x : float
@onready var state_machine = %StateMachine

var current_jump = 1
var jump_count = 2
var attack_hitboxes : Dictionary = {}
var has_sickle = true
# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.75

signal drop_grapple

#variables for animation
@onready var animated_sprite = $AnimatedSprite2D
@export var animation_tree: AnimationTree

func _ready() -> void:
	for hitbox in %AttackBox.get_children():
		attack_hitboxes[hitbox.name] = hitbox
	get_closest_target()
	hp_bar = get_tree().get_first_node_in_group("player_ui")
	if hp_bar:
		hp_bar.update_max_value(max_hp)
	
	
func get_closest_target():
	var closest_target : Node2D
	var closest_distance = INF
	for t : Target in get_tree().get_nodes_in_group("targets"):
		t.targetted = false
		var distance = global_position.distance_to(t.global_position)
		if distance < closest_distance:
			closest_target = t
			closest_distance = distance
	target = closest_target
	if target:
		target.targetted = true
		
func _physics_process(_delta):
	if target:
		grapple_angle = atan2(global_position.y - target.global_position.y, global_position.x - target.global_position.x)
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

	position.x = grapple_amount * x_pos + target.global_position.x
	position.y = grapple_amount * y_pos + target.global_position.y
	
	relative_vector = position - target.global_position
	if abs(relative_vector.x) > abs(relative_vector.y):
		# Horizontal dominant
		normalized_vector = Vector2(sign(relative_vector.x), 0)
	else:
		# Vertical dominant
		normalized_vector = Vector2(0, sign(relative_vector.y))
		
	normalized_x = relative_vector.x / grapple_amount

var hp_bar : HPBar
func take_damage(damage: int):
	animated_sprite.self_modulate = Color(0.6, 0.2901960784313726 ,0.2901960784313726)
	%DamagedParticles.emitting = true
	set_collision_layer_value(2, false)
	current_hp -= damage
	hp_bar.update_hp_bar(damage)
	
	if current_hp <= 0 and !invulnerable:
		pause_screen.pause(true, "YOU LOSE")
	
func _on_cpu_particles_2d_2_finished() -> void:
	animated_sprite.self_modulate = Color(1, 1 ,1)
	set_collision_layer_value(2, true)
	
func init_sound(sound: AudioStreamPlayer2D):
	var rng = RandomNumberGenerator.new()
	var original_pitch = sound.pitch_scale
	sound.pitch_scale += randf_range(-0.15, 0.15)
	sound.play()
	await sound.finished
	sound.pitch_scale = original_pitch

func stop_grapple():
	emit_signal("drop_grapple")
