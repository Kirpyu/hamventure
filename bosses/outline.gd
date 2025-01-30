extends Node2D
class_name Target
@export var grapple_amount : float;
@export var grapple_distance : float;
@export var grapple_speed : float;

var highlighted = false
# can set highlighted when doing for loop
# NEED FROM PLAYER!!!!
var player = null

func _process(delta: float) -> void:
	queue_redraw()
#change this later to self

func _draw():
	if Input.is_action_pressed("lmb"):
		draw_circle(Vector2(0,0), grapple_amount, Color(1, 1, 1, 0.4), false)
		draw_circle(Vector2(0,0), grapple_distance, Color(1, 1, 1, 0.4), false)
		draw_circle(Vector2(cos(player.grapple_angle) * grapple_amount, sin(player.grapple_angle) * grapple_amount), 4, Color(1, 1, 1, 0.4))
