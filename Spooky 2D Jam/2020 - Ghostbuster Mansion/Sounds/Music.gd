extends AudioStreamPlayer

var menu = preload("res://Sounds/Menu.wav")
var level = preload("res://Sounds/Level.wav")

func play_menu():
	if !get_stream() == menu:
		set_stream(menu)
	if !playing:
		play()

func play_level():
	if !get_stream() == level:
		set_stream(level)
	if !playing:
		play()
