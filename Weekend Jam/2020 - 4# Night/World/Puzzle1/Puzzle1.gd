extends Node2D

onready var switch1 = $ObjectsN/Switch
onready var switch2 = $ObjectsN/Switch2

func _ready():
	Global.scene = "Puzzle1"
	Motion.touch_mode = 0
	
	Music.play_music("Town")

func _process(delta):
	if switch1.pressed && switch2.pressed && !Global.puzzle1:
		Global.puzzle1 = true
		Sound.play_sound("Point")
		#Global.save_game()
		Global.join_world()
