extends Node2D

onready var scorel = $UI/Control/Score
onready var hscorel = $UI/Control/Highscore

onready var tsprite = $UI/Control/ColorRect/Sprite
onready var tbg = $UI/Control/ColorRect

func _ready():
	Global.scene == "Level"
	
	Music.play_music("main")
	Gmotion.touch_mode = 2
	
	Global.health = 4
	Global.score = 0	
	Global.can_trap = true

func _process(delta):
	scorel.text = "Score: " + String(Global.score)
	hscorel.text = "Highscore: " + String(Global.highscore)
	
	var r = Global.traps[Global.selected_trap]
	tsprite.texture = load("res://Objects/Traps/" + r + "/" + r + ".png")
	
	if Global.can_trap:
		tbg.color = Color(1,1,1,1)
	else:
		tbg.color = Color(0,0,0,1)


func _on_TouchScreenButton_pressed():
	Input.action_press("action")
	#Input.action_release("action")


func _on_Movement_Button_button_down():
	Gmotion.in_window = true

func _on_Movement_Button_button_up():
	#Gmotion.in_window = false
	pass
