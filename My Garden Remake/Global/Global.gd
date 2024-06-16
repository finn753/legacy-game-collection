extends Node

signal night
signal new_day
signal clean_outside_area
signal captured

signal loaded
signal saving
signal saved
signal deleted

signal force_start

const VERSION = "DEV1"

var selected_game = "debug"
var last_played = ""
var new_garden = false

var starter_flower_s = 0
var starter_flower_c = 5

var player_pos
var cursor_pos

var capture

var tilemap_node

var sleeping = false

var day = 1
var keys = []

#STATS
var time_played = 0
var longest_day = 0
var longest_session = 0

var flowers_watered = 0
var flowers_not_watered = 0
var flowers_overwatered = 0

var screenshots_taken = 0

var species_stats = {}
var color_stats = {}

#func _ready():
#	delete_game(selected_game) # TODO Remove

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("window"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
	
	if Input.is_action_just_pressed("save"):
		save_game()

func save_settings():
	var save_dict = {
		"last_played": last_played
	}
	
	var file = File.new()
	file.open("user://settings.save", File.WRITE)
	file.store_var(save_dict)
	file.close()

func load_settings():
	var save_data
	var file = File.new()
	
	if !file.file_exists("user://settings.save"):
		save_settings()
	
	var err = file.open("user://settings.save", File.READ)
	if err == OK:
		save_data = file.get_var()
	file.close()
	
	if save_data != null:
		for k in save_data.keys():
			if k == "":
				continue
			set(k,save_data[k])

func save_game():
	emit_signal("saving")
	var save_dict = {
		"version": VERSION,
		"starter_flower_c": starter_flower_c,
		"starter_flower_s": starter_flower_s,
		"day": day,
		"keys": keys,
		"time_played": time_played,
		"longest_day": longest_day,
		"longest_session": longest_session,
		"flowers_watered": flowers_watered,
		"flowers_not_watered": flowers_not_watered,
		"flowers_overwatered": flowers_overwatered,
		"screenshots_taken": screenshots_taken,
		"tilemap": [],
		"plants": [],
		"decoration": []
	}
	
	if tilemap_node != null:
		save_dict["tilemap"] = tilemap_node.get_used_cells_by_id(1)
	
	var plant_list = get_tree().get_nodes_in_group("Plant")
	
	#print("Saving plants: " + str(plant_list.size()))
	
	for p in plant_list:
		if !p.has_method("save"):
			print("'%s' no save()" % p.name)
			continue
		
		var plant_data = p.call("save")
		save_dict["plants"].append(plant_data)
	
	var deco_list = get_tree().get_nodes_in_group("Decoration")
	
	for d in deco_list:
		if !d.has_method("save"):
			print("'%s' no save()" % d.name)
			continue
		
		var deco_data = d.call("save")
		save_dict["decoration"].append(deco_data)
	
	var dir = Directory.new()
	if !dir.dir_exists("user://Saves"):
		dir.make_dir("user://Saves")
	
	var file = File.new()
	file.open("user://Saves/" + selected_game + ".save", File.WRITE)
	file.store_var(save_dict)
	file.close()
	emit_signal("saved")
	#load_game() #TODO REMOVE

func load_game(sg = null):
	print("Load")
	if sg == null:
		sg = selected_game
	selected_game = sg
	
	var save_data
	var file = File.new()
	var err = file.open("user://Saves/" + selected_game + ".save", File.READ)
	if err == OK:
		save_data = file.get_var()
	file.close()
	
	if save_data != null:
		for k in save_data.keys():
			if k == "version" || k == "tilemap" || k == "plants":
				continue
			set(k,save_data[k])
	
	emit_signal("loaded")
	return save_data

#func has_game(sg):
#	pass

func delete_game(sg):
	var dir = Directory.new()
	dir.remove("user://Saves/" + sg + ".save")
	emit_signal("deleted")

func get_saved_games():
	var files = []
	var dir = Directory.new()
	
	if !dir.dir_exists("user://Saves"):
		return
	
	dir.open("user://Saves")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with(".") && file.ends_with(".save"):
			file.erase(file.length()-5,5)
			files.append(file)
			
	dir.list_dir_end()
	
	return files

func generate_garden_name(base_name = "My Garden"):
	var gname = base_name
	var csaved = get_saved_games()
	
	var i = 1
	while gname in csaved:
		i += 1
		gname = base_name + " " + str(i)
	
	print("saved:" + str(csaved))
	print(gname)
	
	return gname

func new_day():
	print("New day")
	day += 1
	emit_signal("new_day")
