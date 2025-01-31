extends TextureProgressBar
class_name HPBar

func update_max_value(max_hp: int):
	max_value = max_hp
	value = max_value
	
func update_hp_bar(dmg: int):
	value -= dmg
