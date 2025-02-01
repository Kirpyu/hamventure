extends Projectile

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2), .75)
	tween.play()
	tween.connect("finished", launch)
	sprite.play("default")
	speed = 10
	
func launch():
	speed = 250
