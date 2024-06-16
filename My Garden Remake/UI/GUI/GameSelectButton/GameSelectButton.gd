extends HBoxContainer

func _on_Play_button_down():
	Global.selected_game = $Text.text
	print("Start:" + Global.selected_game)
	Global.emit_signal("force_start")

func _on_Delete_button_down():
	Global.delete_game($Text.text)
	queue_free()
