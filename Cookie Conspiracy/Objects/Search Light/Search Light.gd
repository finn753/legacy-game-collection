extends Area2D

func _on_Search_Light_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			Sound.play_sound("Hit")
			Global.change_scene(Global.scene)
