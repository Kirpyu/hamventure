extends Area2D

@export var attack: int = 10

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		MusicManager.init_sound(%HitSound)
		area.take_damage(attack)
