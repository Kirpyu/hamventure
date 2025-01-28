extends Area2D  # Assuming this script is attached to the Area2D node
class_name Enemy

@export var max_hp = 100
var current_hp = max_hp
var hp_bar : HPBar

var tween: Tween
var initial_pos : Vector2

@onready var target: Node2D = %Target
@onready var player : Player = %Player;

@export var wobble_amount : int = 5
@export var grapple_amount : float= 125
@export var grapple_speed : float = 1.75
@export var grapple_distance : float = 250

#NEED FROM PLAYER!!!!
@export var grapple_angle : float;

#Attack Projectiles
@export var fireball : PackedScene

func _ready():
	hp_bar = get_tree().get_first_node_in_group("hp_bar")
	initial_pos = position
	tween = create_tween()
	wiggle()
	tween.connect("finished", wiggle)
	$AnimatedSprite2D.play("flicker")
	update_target()
	
func update_target():
	%Target.player = player
	%Target.grapple_amount = grapple_amount
	%Target.grapple_distance = grapple_distance

func wiggle():
	var random_offset = Vector2(
		randf_range(-wobble_amount, wobble_amount),
		randf_range(-wobble_amount, wobble_amount)
	)
	tween.stop()
	tween.tween_property(self, "position", initial_pos + random_offset, 1)
	tween.play()

func take_damage(dmg: int):
	current_hp -= dmg
	hp_bar.update_hp_bar(dmg)

func look_at_player() -> Vector2:
	return (player.global_position - %Target.global_position).normalized()
	
func fire_projectile():
	var b = fireball.instantiate()
	if b is Projectile:
		var direction = look_at_player()
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
		b.transform = %Target.global_transform
		b.look_at(player.global_position)
		b.direction = look_at_player()
	


func _on_shoot_timer_timeout() -> void:
	fire_projectile()


var current_attack;
func change_attack(attack_name : String):
	match attack_name:
		"Normal Fireball":
			pass
		_:
			pass
#	make physics process match an attack function

## This function is called after every attack in order to change the current attack
func phase_change() -> void:
	pass
#	this is called after every attack
#get random num, then match that number with whatever attack we feeling, then swap current attack with whatever our new attack is
#	we cana ctually try out a dictionary here, would be hella helpful, match dictionary instead of matching here
# something like change_attack(attacks[random num])
