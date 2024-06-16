extends Node

const VERSION = "1.1"

var pass_background_animation

var minigame = ""

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("window"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

