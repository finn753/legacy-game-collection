extends Node2D

onready var switch = $Switch
onready var pivot = $Gravity

var rotate = 90

func _ready():
	Global.scene = "Puzzle3"
	Motion.touch_mode = 0
	
	Music.play_music("Town")

func _process(delta):
	#pivot.rotation_degrees += rotate * delta
	pivot.direction = pivot.direction.rotated(deg2rad(rotate*delta))
	
	if switch.pressed && !Global.puzzle3:
		Sound.play_sound("Point")
		Global.puzzle3 = true
		#Global.save_game()
		Global.join_world()
