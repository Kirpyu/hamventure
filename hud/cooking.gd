extends PathFollow2D

var time_elapsed : float
func _physics_process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed > 0:
		time_elapsed = 0
	
	progress_ratio = time_elapsed
