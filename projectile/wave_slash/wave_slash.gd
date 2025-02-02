extends Projectile

@export var flipped: bool

func _ready() -> void:
	#global_position.y = 20
	sprite.play("default")
	if flipped:
		sprite.flip_h = true
		speed *= -1

func _physics_process(delta: float) -> void:
	position.x += speed * delta
