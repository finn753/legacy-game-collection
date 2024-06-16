extends Node2D

onready var overview_cam = $Overview

onready var player = $Objects/Player
onready var player_cam = $Objects/Player/Camera2D

onready var ritual = $Ritual
onready var ritual_cam = $"Ritual/Ritual Cam"

func _ready():
	Global.scene = "World"
	Motion.touch_mode = 2
	
	if Global.player_position != null:
		player.position = Global.player_position
	
	Music.play_music("Town")

func _process(delta):
	if Global.scene == "World":
		Global.player_position = player.position + Vector2(0,2)
	
	if Input.is_action_pressed("hint"):
		ritual_cam.current = true
	elif Input.is_action_pressed("Overview"):
		overview_cam.current = true
	else:
		player_cam.current = true
	
	if Global.puzzle1:
		ritual.set_cell(-41,35,15)
	else:
		ritual.set_cell(-41,35,14)
	
	if Global.puzzle2:
		ritual.set_cell(-29,35,17)
	else:
		ritual.set_cell(-29,35,16)
	
	if Global.puzzle3:
		ritual.set_cell(-35,29,19)
	else:
		ritual.set_cell(-35,29,18)
	
	if Global.puzzle4:
		ritual.set_cell(-35,41,21)
	else:
		ritual.set_cell(-35,41,20)
