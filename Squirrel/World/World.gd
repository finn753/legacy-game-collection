extends Node2D

onready var transition = $UI/Transition
onready var tilemap = $WorldMap

func _ready():
	Global.text_box = ""
	Global.current_coins = 0
	transition.open(2.0)
	transition.connect("closed",self,"is_closed")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		var _error = get_tree().change_scene("res://UI/Menu.tscn")

func _on_Music_finished():
	transition.close(5.0)

func is_closed():
	print("Closed")
	if Global.max_coins == Global.current_coins:
		var _error = get_tree().change_scene("res://UI/Menu.tscn")
