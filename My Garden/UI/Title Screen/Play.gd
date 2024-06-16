extends Sprite

func _ready():
	if !Global.has_save_game():
		queue_free()

func grab():
	var err = get_tree().change_scene("res://World/Garden/Garden.tscn")
	if err == 0:
		err = 0

func ungrab():
	pass

