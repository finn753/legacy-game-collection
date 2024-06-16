extends StaticBody2D


func _on_Area2D_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			Sound.play_sound("End")
			get_tree().change_scene("res://UI/Menu.tscn")
