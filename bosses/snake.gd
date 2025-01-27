extends Area2D  # Assuming this script is attached to the Area2D node
class_name Enemy

@export var max_hp = 100
var current_hp = max_hp
var hp_bar : HPBar

var tween: Tween
var initial_pos : Vector2

@onready var target: Node2D = %Target
@onready var player = %Player;

@export var wobble_amount : int = 5
@export var grapple_amount : float= 125
@export var grapple_speed : float = 1.75
@export var grapple_distance : float = 250

#NEED FROM PLAYER!!!!
@export var grapple_angle : float;

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

func look_at_player():
	pass
	
func fire_projectile():
	pass
