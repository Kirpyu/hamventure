extends Area2D
class_name Projectile

@export var damage = 25
@export var max_speed: float
@onready var speed = max_speed

@export var sprite : AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_area_entered(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		queue_free()
