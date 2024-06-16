extends Node

const VERSION = "1.1"

var progress = -1 #-1 - 0 = Tutorial
var mode = 1 #0 = endless | 1 = Chapter 1
var scene = "Spawn"

var player_light = false
var deaths = 0

func death():
	deaths += 1
	get_tree().change_scene("UI/Death.tscn")
	player_light = false

func load_menu():
	scene = "Menu"
	get_tree().change_scene("UI/Menu/Menu.tscn")

func load_room(room):
	scene = room
	Input.action_release("up")
	Input.action_release("right")
	Input.action_release("left")
	Input.action_release("down")
	
	if room == "End":
		get_tree().change_scene("Levels/" + room + "/" + room + ".tscn")
	else:
		if mode == 1:
			get_tree().change_scene("Levels/Chapter 1/" + room + "/" + room + ".tscn")
		else:
			return ERR_CANT_OPEN
	print(scene)
	print(String(progress))
	
	Music.play_level()
