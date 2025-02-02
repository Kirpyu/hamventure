extends Area2D
class_name Projectile

@export var damage = 25
@export var max_speed: float
@export var hitbox : CollisionShape2D

@onready var speed = max_speed
@onready var velocity = direction * speed

@export var sprite : AnimatedSprite2D
@export var particles : CPUParticles2D
@export var death_particles: CPUParticles2D

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	sprite.play("default")
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		queue_delete()
	if body is TileMapLayer:
		queue_delete()

func queue_delete():
	hitbox.set_deferred("disabled", true)
	sprite.hide()
	particles.emitting = false
	if death_particles:
		death_particles.emitting = true

func _on_cpu_particles_2d_finished() -> void:
	queue_free()


func _on_death_timer_timeout() -> void:
	queue_free()
