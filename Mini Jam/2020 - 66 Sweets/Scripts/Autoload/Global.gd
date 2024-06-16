extends Node

const VERSION = "1.1"

var scene = ""

var highscore = 0
var score = 0
var new_hs = false

var selected_trap = 0
var traps = ["Boost","Slime","Brake","Donut","Oil","Trap"]
var wait_time = [1  ,2      ,2      ,2      ,3    ,15]
var can_trap = true

var health = 4

func _ready():
	randomize()

func load_menu():
	scene = "Menu"
	get_tree().change_scene("UI/Menu/Menu.tscn")

func load_level():
	scene = "Level"
	get_tree().change_scene("Level/Level.tscn")

func death():
	if score > highscore:
		highscore = score
		new_hs = true
	else:
		new_hs = false
	
	get_tree().change_scene("UI/Death/Death.tscn")

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var save_data = {
		"highscore": highscore
	}
	
	save_game.store_line(to_json(save_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	save_game.open("user://savegame.save", File.READ)
	
	while save_game.get_position() < save_game.get_len():
		var save_data = parse_json(save_game.get_line())
		highscore = save_data["highscore"]
	
	save_game.close()
