extends TextureProgressBar
class_name HPBar

func _ready() -> void:
	#if max_value == value:
		#hide()
	pass


func update_max_value(max_hp: int):
	max_value = max_hp
	value = max_value
	
func update_hp_bar(dmg: int):
	#show()
	value -= dmg
