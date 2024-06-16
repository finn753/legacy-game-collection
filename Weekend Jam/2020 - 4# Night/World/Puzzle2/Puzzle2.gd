extends Node2D

onready var switch = $Switch

func _ready():
	Global.scene = "Puzzle2"
	Motion.touch_mode = 0
	
	Music.play_music("Town")

func _physics_process(delta):
	if switch.pressed && !Global.puzzle2:
		Sound.play_sound("Point")
		Global.puzzle2 = true
		#Global.save_game()
		Global.join_world()
