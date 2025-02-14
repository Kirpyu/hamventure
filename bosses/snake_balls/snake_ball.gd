extends Area2D

@onready var player : Player = %Player;
@export var fireball : PackedScene
@export var flip : bool
@export var sprite : Sprite2D
@export var max_hp : int
@export var death_particles : CPUParticles2D
@export var dead := false

var angle : float = 0
@export var clock : float = 12.0

@onready var hp = max_hp
@export var hp_bar : HPBar

@export var sfx : AudioStreamPlayer2D

func _ready() -> void:
	if flip:
		sprite.flip_h = true
	%Target.player = player
	hp_bar.update_max_value(max_hp)

func _on_shoot_timer_timeout() -> void:
	fire_projectile()

func fire_projectile():
	var b = fireball.instantiate()
	if b is Projectile:
		get_tree().get_first_node_in_group("projectile_node").add_child(b)
		b.transform = %Target.global_transform
		b.rotate(deg_to_rad(angle))
		b.direction = Vector2.RIGHT.rotated(deg_to_rad(angle))
		angle += float(360) / clock

func look_at_player() -> Vector2:
	return (player.global_position - %Target.global_position).normalized()

func take_damage(dmg:int):
	hp -= dmg
	hp_bar.update_hp_bar(dmg)
	if hp <= 0:
		queue_delete()
	#elif %Cooldown.is_stopped():
		#%Cooldown.start()
	MusicManager.init_sound(sfx)
	
func queue_delete():
	sprite.hide()
	hp_bar.hide()
	dead = true
	$ShootTimer.stop()
	remove_from_group("enemy")
	%Target.remove_from_group("targets")
	%Target.dead = true
#	to avoid writing all of these, i should find a way to signal player if dead, stop grappling
	if death_particles:
		death_particles.emitting = true
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		get_tree().get_first_node_in_group("boss").second_phase()
		
func _on_queue_free_particles_finished() -> void:
	pass
