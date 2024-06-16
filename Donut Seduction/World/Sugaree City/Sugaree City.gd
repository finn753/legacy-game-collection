extends Node2D

onready var player = $YSort/Player

var limitX = Vector2(-320,1344)
var limitY = Vector2(-736,768)

func _ready():
	player.camera.limit_left = limitX.x
	player.camera.limit_right = limitX.y
	player.camera.limit_top = limitY.x
	player.camera.limit_bottom = limitY.y
	
	Global.score = 0
	Global.current_trap = ""
	
	Audio.play_music("Sugaree City")
	Audio.play_sound("Spawn",true)
