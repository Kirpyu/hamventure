extends Node2D


func _on_button_button_down() -> void:
	%ButtonClick.play()
	%TransitionScreen.target_scene = load("res://scenes/boss_levels/snake_boss_level.tscn")
	%TransitionScreen.transition_screen()
