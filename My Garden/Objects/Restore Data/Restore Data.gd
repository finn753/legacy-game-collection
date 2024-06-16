extends Node2D

var days = 1

func _ready():
	pass
	if Global.day == 1:
		Global.day = days
	else:
		days = Global.day

func save():
	days = Global.day
	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"days" : days,
	}
	return save_dict
