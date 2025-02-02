extends Projectile

func _ready() -> void:
	MusicManager.init_sound(%FireballSFX)
	sprite.play("default")
