extends Node2D

@onready var player = %Player

func _process(delta: float) -> void:
	queue_redraw()
#change this later to self
func _draw():
	if player.grappled:
		draw_circle(Vector2(0,0), 50, Color(1, 1, 1, 0.4), false)
	
	if Input.is_action_pressed("lmb"):
		draw_circle(Vector2(0,0), 50, Color(1, 1, 1, 0.4), false)
		draw_circle(Vector2(0,0), 150, Color(1, 1, 1, 0.4), false)
		draw_circle(Vector2(cos(player.grapple_angle) * 50, sin(player.grapple_angle) * 50), 4, Color(1, 1, 1, 0.4))
