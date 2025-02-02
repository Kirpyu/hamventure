extends Control

@export var tutorial_scene : PackedScene
@export var secret_scene : PackedScene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(secret_scene)
