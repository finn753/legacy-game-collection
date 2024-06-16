extends Sprite

const TYPE = "Sprinkler"

var puffer = 2

func get_type():
	return TYPE

func _process(_delta):
	if puffer > 0:
		puffer -= 1
	elif puffer == 0:
		for a in $Area2D.get_overlapping_areas():
			_on_Area2D_area_entered(a)
			
		puffer = -25

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
	}
	return save_dict

func _on_Area2D_area_entered(a):
	if a.get_parent().has_method("water"):
		a.get_parent().water()
