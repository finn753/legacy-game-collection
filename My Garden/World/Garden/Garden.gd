extends Node2D

func _ready():
	Audio.play_music("Flower Jam")
	Audio.play_sound("Door")
	
	Global.load_game()
	if Global.update_day:
		Global.update_day = false
		Global.emit_signal("new_day")


func _on_Save_Timer_timeout():
	Global.save_game()
