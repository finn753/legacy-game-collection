extends Node

const VERSION = "1.1"

var scene = ""
var progress = 0

var notes = []
var keys = []

func change_scene(s):
	get_tree().change_scene("res://Scenes/" + s + "/" + s + ".tscn")
	Sound.play_sound("Teleport")

func save_game():
	#TODO
	pass

func load_game():
	#TODO
	pass

func has_save_game():
	#TODO
	return false
