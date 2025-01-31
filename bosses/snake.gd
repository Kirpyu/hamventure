extends Area2D  # Assuming this script is attached to the Area2D node
class_name Enemy

@export var max_hp = 100
var current_hp = max_hp

var tween: Tween
@export var animation_player : AnimationPlayer

@onready var target: Node2D = %Target
@onready var player : Player = %Player

@export var wobble_amount : int = 5
@export var grapple_amount : float
@export var grapple_speed : float = 1.75
@export var grapple_distance : float = 250

#NEED FROM PLAYER!!!!
@export var grapple_angle : float;

#Attack Projectiles
@export var fireball : PackedScene
@export var fireball_lob : PackedScene
@export var tail: PackedScene
@export var lava: PackedScene

#Attack Data
const attacks : Array = ["Normal Fireball", "Spew Attack", "Tail Slam", "Lava Spike"]

func _physics_process(delta: float) -> void:
#	DEBUGGING BUTTON
	if Input.is_action_just_pressed("jump"):
		pass

func _ready():
	
	follow_player()
	animation_player.play("default")
	update_target()
	start_spew_attack()
	
	for hp_bar in get_tree().get_nodes_in_group("hp_bar"):
		hp_bar.update_max_value(max_hp)
	
func update_target():
	%Target.player = player
	
func follow_player():
	if tween:
		tween.kill()
	tween = create_tween()
	var target_pos = player.global_position / 3
	#var random_offset = Vector2(
		#randf_range(-wobble_amount, wobble_amount),
		#randf_range(-wobble_amount, wobble_amount)
	#)
	
	tween.tween_property(self, "position", Vector2(target_pos.x, position.y), 1)
	tween.play()
	tween.connect("finished", follow_player)

func take_damage(dmg: int):
	current_hp -= dmg
	for hp_bar in get_tree().get_nodes_in_group("hp_bar"):
		hp_bar.update_hp_bar(dmg)

func look_at_player() -> Vector2:
	return (player.global_position - %Target.global_position).normalized()
	
func fire_projectile():
	animation_player.play("mouth_open")
	var b = fireball.instantiate()
	if b is Projectile:
		var direction = look_at_player()
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
		b.transform = %Target.global_transform
		b.look_at(player.global_position)
		b.direction = look_at_player()
	
var current_attack : String;
## Changes the snake's current attack by randomizing through the attack array
## Ensures that the same attack does not play twice in a row
func change_attack():
	var rng = RandomNumberGenerator.new()
	var random_attack : String = attacks[rng.randi_range(0, attacks.size() - 1)]
	while random_attack == current_attack:
		random_attack = attacks[rng.randi_range(0, attacks.size() - 1)]
	current_attack = random_attack
	match random_attack:
		"Normal Fireball":

			fire_projectile()
#			Phase change should actually pop on signal, not right away, since this is how we change phases
			phase_change()
		"Spew Attack":
			start_spew_attack()
		"Tail Slam":
			tail_slam()
			phase_change()
		"Lava Spike":
			start_spew_attack()
		_:
			pass

## This function is called after every attack in order to change the current attack
func phase_change() -> void:
	%CooldownTimer.start()

func start_spew_attack():
	animation_player.play("mouth_open")
	match current_attack:
		attacks[1]:
			%TickTimer.wait_time = .1
		attacks[3]:
			%TickTimer.wait_time = .2
	%TickTimer.start()
	%SpewTimer.start()
	
func spew_attack():
	var b = fireball_lob.instantiate()
	if b is Projectile:
		b.transform = %Target.global_transform
		get_tree().get_first_node_in_group("projectile_node").add_child(b)

func tail_slam():
	var b = tail.instantiate()
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(0, 1) == 1:
		b.flip = true
	if b is Projectile:
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
		
func lava_spout():
	var b = lava.instantiate()
	if b is Projectile:
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
	
func _on_tick_timer_timeout() -> void:
	match current_attack:
		attacks[1]:
			spew_attack()
		attacks[3]:
			lava_spout()
		_:
			phase_change()

func _on_spew_timer_timeout() -> void:
	%TickTimer.stop()
	phase_change()

func _on_cooldown_timer_timeout() -> void:
	change_attack()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"mouth_open":
			animation_player.play("default")
