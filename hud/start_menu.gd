extends Control

@export var tutorial_scene : PackedScene
@export var secret_scene : PackedScene

func _on_start_pressed() -> void:
	MusicManager.init_sound(%ButtonClick)
	%TransitionScreen.transition_screen()

func _on_quit_pressed() -> void:
	MusicManager.init_sound(%ButtonClick)
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(secret_scene)


func _on_start_mouse_entered() -> void:
	MusicManager.init_sound(%ButtonHover)


func _on_quit_mouse_entered() -> void:
	MusicManager.init_sound(%ButtonHover)
