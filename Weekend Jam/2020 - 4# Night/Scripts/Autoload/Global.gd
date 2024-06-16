extends Node

const VERSION = "1.1"

var scene = "Menu"
var player_position = null

var puzzle1 = false
var puzzle2 = false
var puzzle3 = false
var puzzle4 = false

func join_menu():
	scene = "Menu"
	get_tree().change_scene("UI/Menu/Menu.tscn")

func join_world():
	scene = "World"
	Motion.release()
	get_tree().change_scene("World/World.tscn")
	#Global.save_game()

func join_room(r):
	scene = r
	Motion.release()
	get_tree().change_scene("World/" + r + "/" + r + ".tscn")
	#Global.save_game()

func join_end():
	scene = "End"
	Motion.release()
	get_tree().change_scene("UI/End/End.tscn")
	#Global.save_game()

#func save_game():
#	var save_game = File.new()
#	save_game.open("user://savewej4fp.save", File.WRITE)
#
#	var save_data = {
#		"position": player_position,
#		"puzzle1": puzzle1,
#		"puzzle2": puzzle2,
#		"puzzle3": puzzle3,
#		"puzzle4": puzzle4
#	}
#
#	save_game.store_line(to_json(save_data))
#	save_game.close()
#
#func load_game():
#	var save_game = File.new()
#	if not save_game.file_exists("user://savewej4fp.save"):
#		return
#
#	save_game.open("user://savegame.save", File.READ)
#
#	while save_game.get_position() < save_game.get_len():
#		var save_data = parse_json(save_game.get_line())
#		player_position = save_data["position"]
#		puzzle1 = save_data["puzzle1"]
#		puzzle2 = save_data["puzzle2"]
#		puzzle3 = save_data["puzzle3"]
#		puzzle4 = save_data["puzzle4"]
#
#	save_game.close()
#
#func delete_game():
#	scene = "Menu"
#	player_position = null
#
#	puzzle1 = false
#	puzzle2 = false
#	puzzle3 = false
#	puzzle4 = false
#
#	save_game()
