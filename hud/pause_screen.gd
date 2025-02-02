extends Control
class_name PauseScreen

var _is_paused:bool = false:
	set = set_paused

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if %EndScreen._is_paused == false:
			_is_paused = !_is_paused

var is_beat := false
func pause(value:bool, input: String):
	%Label.text = input
	if input == "Well done":
		is_beat = true
		show()
		%restart.text = "NEXT"
		return
	
	set_paused(value)

func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	
func resume_game():
	_is_paused = false
	
func _on_resume_button_pressed() -> void:
	resume_game()


func _on_quit_pressed() -> void:
	resume_game()
	get_tree().quit()

@export var restart_scene : PackedScene
@onready var snake_boss : PackedScene = load("res://scenes/boss_levels/snake_boss_level.tscn")
@onready var tengu_boss : PackedScene = load("res://scenes/boss_levels/tengu_boss_level.tscn")
func _on_restart_pressed() -> void:
	if is_beat:
		%TransitionScreen.target_scene = snake_boss
		%TransitionScreen.transition_screen()
		return
	%TransitionScreen.target_scene = tengu_boss
	%TransitionScreen.transition_screen()
