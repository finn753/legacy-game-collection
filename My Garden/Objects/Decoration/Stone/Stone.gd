extends AnimatedSprite

func grab():
	pass

func ungrab():
	pass

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"animation" : animation,
	}
	return save_dict
