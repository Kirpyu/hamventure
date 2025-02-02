extends CPUParticles2D

var showing_portal := false
@export var first_scene : PackedScene
func _physics_process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemy").size() == 0 and !showing_portal:
		showing_portal = true
		emitting = true
		$Area2D/CollisionShape2D.set_deferred("disabled", false)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	$Area2D/CollisionShape2D.call_deferred("queue_free")
	$Area2D.call_deferred("queue_free")
	get_tree().change_scene_to_packed(first_scene)
