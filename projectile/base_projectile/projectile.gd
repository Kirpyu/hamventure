extends Area2D
class_name projectile

@export var damage = 25

func _on_area_entered(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
