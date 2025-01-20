extends Area2D  # Assuming this script is attached to the Area2D node

var tween: Tween
var initial_pos : Vector2
@export var wobble_amount : int = 5
func _ready():
	
	initial_pos = position
	tween = create_tween()
	wiggle()
	tween.connect("finished", wiggle)
	$AnimatedSprite2D.play("flicker")

func wiggle():
	var random_offset = Vector2(
		randf_range(-wobble_amount, wobble_amount),
		randf_range(-wobble_amount, wobble_amount)
	)
	tween.stop()
	tween.tween_property(self, "position", initial_pos + random_offset, 1)
	tween.play()
