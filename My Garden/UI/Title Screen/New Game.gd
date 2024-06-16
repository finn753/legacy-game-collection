extends Sprite

func grab():
	Global.delete_game()
	var err = get_tree().change_scene("res://World/Garden/Garden.tscn")
	if err == 0:
		err = 0

func ungrab():
	pass
