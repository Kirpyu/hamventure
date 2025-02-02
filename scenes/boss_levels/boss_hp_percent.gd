extends Label

var max_value;
var value;

func update_max_value(max_hp: int):
	max_value = max_hp
	value = max_value
	text = str(max_value) + "%"
	
func update_hp_bar(dmg: int):
	value -= dmg
	text = str((float(value) / float(max_value)) * 100) + "%"
