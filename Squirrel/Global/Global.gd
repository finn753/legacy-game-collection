extends Node

signal time_changed

var player

var max_coins = 7
var current_coins = 0

var time = 0

var text_box = ""

var tutorial_walking_completed = false
var tutorial_climbing_completed = false
var tutorial_nuts_completed = false
var tutorial_age_completed = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func init_coin():
	#max_coins += 1
	max_coins = 7

func collect_coin():
	current_coins += 1

func set_time(t):
	time = t
	emit_signal("time_changed")
	print(t)

func restart_game():
	max_coins = 0
	current_coins = 0
	time = 0
	text_box = ""
	
	var _error = get_tree().reload_current_scene()
