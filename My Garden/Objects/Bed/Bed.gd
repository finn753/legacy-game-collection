extends Area2D

func _on_Bed_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			if !Global.update_day:
				Audio.play_sound("NewDay")
				Global.next_day()
