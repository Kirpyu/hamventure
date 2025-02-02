extends ColorRect
class_name TransitionScreen
@export var target_scene : PackedScene
var tween : Tween

func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()


func _ready():
	reset_tween()
	tween.tween_property(self, "color", Color.TRANSPARENT, 2.5).set_trans(Tween.TRANS_CUBIC)

func transition_screen():
	if !tween.is_running():
		reset_tween()
		tween.tween_property(self, "color", Color.BLACK, 1.75).set_trans(Tween.TRANS_CUBIC)
		tween.connect("finished", change_scene)
	
func change_scene():
	get_tree().change_scene_to_packed(target_scene)
