extends Control

@export var tutorial_scene : PackedScene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
