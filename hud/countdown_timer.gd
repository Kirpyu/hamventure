extends "res://hud/pause_screen.gd"

@export var countdown_sfx : AudioStreamPlayer
@export var do_countdown := false

func _ready() -> void:
	if do_countdown:
		start_countdown()
	else:
		hide()
		
func _physics_process(_delta: float) -> void:
	$Label.text = str(ceili($Label/Timer.time_left))
	
func start_countdown():
	countdown_sfx.play()
	set_paused(true)
	$Label/Timer.start()
	$Label/Timer.wait_time = 3
	
func _on_timer_timeout() -> void:
	set_paused(false)
