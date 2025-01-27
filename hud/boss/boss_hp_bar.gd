extends ProgressBar
class_name HPBar

func update_hp_bar(dmg: int):
	value -= dmg
