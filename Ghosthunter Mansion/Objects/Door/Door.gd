extends Area2D

enum door_dirs {LEFT = -1,RIGHT = 1,UP = 10,DOWN = -10}

export(door_dirs) var door_dir = door_dirs.LEFT

func _on_Door_body_entered(body):
	if body.has_method("is_player"):
		Global.old_room = Global.current_room
		print("dir: " + str(door_dir))
		Global.current_room += door_dir
		
		get_tree().reload_current_scene()
