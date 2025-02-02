extends Area2D

@onready var player : Player = %Player;
@export var max_hp : int
@export var death_particles : CPUParticles2D
@export var target: Target
@export var animation_player : AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var clone : bool
var clone_node
@export var attack_animation_player : AnimationPlayer
var dead := false

var attacks : Array[String] = ["Middle Down Dash", "Sideward Dash", "Left Down Dash", "Right Down Dash", "Left Diagonal Dash", "Right Diagonal Dash"]
var amount_of_attacks := 0
var current_attack : String

var reset_pos : Vector2
var current_pos : Vector2
@onready var hp = max_hp
@export var hp_bar : HPBar
var tween : Tween

var upper_left : Vector2
var upper_right : Vector2
var bottom_left : Vector2 
var bottom_right : Vector2
var bottom_middle : Vector2
var upper_middle : Vector2
var middle : Vector2

@export var blink_timer : Timer

func _ready() -> void:
	reset_pos = get_global_transform().origin
	current_pos = reset_pos
	set_corners()
	
	
	if target:
		target.player = player
		
	if hp_bar:
		hp_bar.update_max_value(max_hp)
	animation_player.play("default")
	start_down_dash()
	
	if clone:
		animated_sprite.modulate = Color(0, 0, 0, 1)
		%Hurtbox.set_deferred("disabled", true)
		pause()
	else:
		clone_node = %Clone

func set_corners():
	upper_left = Vector2(reset_pos.x - 220, reset_pos.y)
	upper_right = Vector2(reset_pos.x + 220, reset_pos.y)
	bottom_left = Vector2(reset_pos.x - 220, reset_pos.y + 128)
	bottom_right = Vector2(reset_pos.x + 220, reset_pos.y + 128)
	bottom_middle = Vector2(0, reset_pos.y + 128)
	upper_middle = reset_pos
	middle = Vector2(reset_pos.x, reset_pos.y + 52)

func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()

func start_down_dash():
	current_attack = "Middle Down Dash"
	position = upper_middle
	blink(2, 0.75)
	attack_animation_player.play("Middle Down Dash")

func down_dash():
	
	animation_player.play("down_dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_middle, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func start_left_down_dash():
	reset_tween()
	tween.tween_property(self, "position", upper_left, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	position = upper_left
	blink(2, 0.75)
	attack_animation_player.play("Left Down Dash")

func left_down_dash():
	animation_player.play("down_dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_left, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func start_right_down_dash():
	position = upper_right
	blink(2, 0.75)
	attack_animation_player.play("Right Down Dash")

func right_down_dash():
	animation_player.play("down_dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_right, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func start_left_diagonal_dash():
	position = upper_left
	blink(1, 0.75)
	attack_animation_player.play("Left Diagonal Dash")

func left_diagonal_dash():
	animation_player.play("left_diagonal_dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_right, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func start_right_diagonal_dash():
	current_attack = "Right Diagonal Dash"
	position = upper_right
	blink(1, 0.75)
	attack_animation_player.play("Right Diagonal Dash")

func right_diagonal_dash():
	animation_player.play("right_diagonal_dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_left, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func start_sideward_dash():
	position = bottom_left
	blink(3, 0.75)
	attack_animation_player.play("Sideward Dash")
	
func sideward_dash():
	animation_player.play("dash")
	reset_tween()
	tween.tween_property(self, "position", bottom_right, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

func play_slash():
	if current_attack != "Right Diagonal Dash":
		animation_player.play("slash_right")
	else:
		animation_player.play("slash_left")
	%CooldownTimer.start()

func slash_wave():
	play_slash()
	match current_attack:
		"Left Down Dash":
			fire_projectile(bottom_left, false)
		"Right Down Dash":
			fire_projectile(bottom_right, true)
		"Middle Down Dash":
			fire_projectile(bottom_middle, true)
			fire_projectile(bottom_middle, false)

func blink(amount: int, duration: float):
	reset_tween()
	var blink_amount = amount
	blink_timer.wait_time = .75
	blink_timer.start()
	while blink_amount > 0:
		tween.tween_property(animated_sprite, "self_modulate", Color.INDIAN_RED, duration / (2.0 * float(amount))).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 1.0 * duration / (2.0 * float(amount))).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		blink_amount -= 1

@export var pick_attack_timer : Timer
## Bandaid Fix: Created Cooldown Timer
## Picks a random attack to carry out
func pick_attack():
	if !clone and pick_attack_timer.is_stopped():
		pick_attack_timer.start()
		amount_of_attacks += 1
		if amount_of_attacks >= 5:
			amount_of_attacks = 0
			rest()
			return

		var temp_attack = current_attack
		while temp_attack == current_attack:
			current_attack = attacks[randi_range(0, attacks.size() - 1)]
			if is_second_phase and clone_node.visible == true:
				var clone_attack = current_attack
				while current_attack == clone_attack:
					current_attack = attacks[randi_range(0, attacks.size() - 1)]
				clone_node.current_attack = clone_attack
				clone_node.match_attack()
				match_attack()
			else:
				match_attack()

var count: int = 0
func match_attack():
	attack_animation_player.play(&"RESET")
	attack_animation_player.advance(0)
	count += 1
	match current_attack:
		"Middle Down Dash":
			start_down_dash()
		"Sideward Dash":
			start_sideward_dash()
		"Left Diagonal Dash":
			start_left_diagonal_dash()
		"Right Diagonal Dash":
			start_right_diagonal_dash()
		"Left Down Dash":
			start_left_down_dash()
		"Right Down Dash":
			start_right_down_dash()
	
	if current_attack != "Right Diagonal Dash":
		animation_player.play("sheath_right")
	else:
		animation_player.play("sheath_left")

@export var pause_screen : PauseScreen
func take_damage(dmg:int):
	if !clone:
		hp -= dmg
		if hp_bar:
			hp_bar.update_hp_bar(dmg)
		if hp <= max_hp / 2 and !is_second_phase:
			second_phase()
		if hp <= 0:
			pause_screen.pause(true, "You Win")

var is_second_phase := false

func second_phase():
	is_second_phase = true
	%Clone.is_second_phase = true

@export var rest_timer : Timer
func rest():
	if !clone:
		clone_node.pause()
		animation_player.play("tired") 
		position = middle
		rest_timer.start()


## Follows Up on what attack to do/ Change This To Whatever Current Attack Is
func _on_timer_timeout() -> void:
	match current_attack:
		"Middle Down Dash":
			down_dash()
		"Sideward Dash":
			sideward_dash()
		"Left Diagonal Dash":
			left_diagonal_dash()
		"Right Diagonal Dash":
			right_diagonal_dash()
		"Left Down Dash":
			left_down_dash()
		"Right Down Dash":
			right_down_dash()

## Picks next attack after cooldown/ tengu breathing time ends
## Cooldown starts after any dash animatione ends (0.25 seconds after dash animation starts)
func _on_cooldown_timer_timeout() -> void:
	pick_attack()
	
@export var wave_slash_projectile: PackedScene
func fire_projectile(pos : Vector2, flipped: bool):
	var b = wave_slash_projectile.instantiate()
	b.global_position = pos + Vector2(0, 12)
	if is_second_phase:
		b.max_speed = 250
	if flipped:
		b.flipped = true
	get_tree().get_first_node_in_group("projectile_node").add_child(b)

func queue_delete():
	pass

func _on_rest_timer_timeout() -> void:
	if !clone and is_second_phase:
		animation_player.play("sheath_right")
		await clone_node.unpause()
		pick_attack()
	elif !clone:
		pick_attack()

func pause():
	current_attack = ""
	hide()
	

func unpause():
	show()
	pick_attack()

func _on_start_attack() -> void:
	pass
