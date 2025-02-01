extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(25)
		$LavaBox.set_deferred("disabled", true)
		await get_tree().create_timer(0.25).timeout
		$LavaBox.set_deferred("disabled", false)
