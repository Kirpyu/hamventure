extends Projectile

@export var cone_angle : float
var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()
	
func _ready() -> void:
	MusicManager.init_sound(%FireballSFX)
	var rand_angle = deg_to_rad(randf_range(-cone_angle / 2, cone_angle / 2))
	direction = Vector2.UP.rotated(rand_angle)
	velocity = direction * speed
