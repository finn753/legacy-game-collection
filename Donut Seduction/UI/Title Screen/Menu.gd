extends ParallaxBackground

func _ready():
	get_tree().paused = false
	
	Audio.play_music("")

func _on_Play_button_down():
	Global.change_scene("res://World/Sugaree City/Sugaree City.tscn")

func _on_SettingsButton_button_down():
	$Settings._on_Exit_button_down()
