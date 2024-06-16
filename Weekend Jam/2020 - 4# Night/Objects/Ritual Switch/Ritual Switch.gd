extends Area2D

func _on_Ritual_Switch_body_entered(body):
	Sound.play_sound("Press")
	get_parent().set_cell(-35,35,13)
	
	if Global.puzzle1 && Global.puzzle2 && Global.puzzle3 && Global.puzzle4:
		Sound.play_sound("Point")
		Global.join_end()

func _on_Ritual_Switch_body_exited(body):
	get_parent().set_cell(-35,35,12)
