extends Area2D
class_name MiniEnemy

@onready var player : Player = %Player;
@export var flip : bool
@export var sprite : Sprite2D
@export var max_hp : int
@export var death_particles : CPUParticles2D
@export var target: Target
@export var animation_player : AnimationPlayer
var dead := false

@onready var hp = max_hp
@export var hp_bar : HPBar

func _ready() -> void:
	if flip:
		sprite.flip_h = true
	if target:
		target.player = player
	hp_bar.update_max_value(max_hp)
	animation_player.play("default")

func take_damage(dmg:int):
	hp -= dmg
	hp_bar.update_hp_bar(dmg)
	if hp <= 0:
		queue_delete()

@export var dynamic_label : Label
func queue_delete():
	sprite.hide()
	hp_bar.hide()
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	remove_from_group("enemy")
	if target:
		target.remove_from_group("targets")
		target.dead = true

	if death_particles:
		death_particles.emitting = true
	if dynamic_label:
		match get_tree().get_nodes_in_group("enemy").size():
			0:
				dynamic_label.text = "Great job, enter the shrine and save the world"
			1:
				dynamic_label.text = "That orb seems to be higher, try
				holding your attack button to grapple, then
				press attack again while you are grappled"
			_:
				pass
			
		
