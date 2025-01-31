extends Marker2D
var player : Player
var tween: Tween
func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("player")
	follow_player()
	
func follow_player():
	if tween:
		tween.kill()
	tween = create_tween()
	
	if global_position.distance_to(player.global_position) > %LeftEye.global_position.distance_to(player.global_position):
		tween.tween_property(self, "rotation", (player.global_position - %LeftEye.global_position).angle(), 0.5)
	else:
		tween.tween_property(self, "rotation", (player.global_position - global_position).angle(), 0.5)
	tween.play()
	tween.tween_callback(follow_player) 
