extends Node

const VERSION = "1.1"

var day = 1
var update_day = false

var message = ""

signal new_day
signal new_message

func _input(_event):
	if Input.is_action_just_pressed("window"):
		OS.window_fullscreen = !OS.window_fullscreen

func next_day():
	#save_game()
	day += 1
	update_day = true
	emit_signal("new_day")

func new_message(m):
	message = m
	emit_signal("new_message",m)

func save_game():
	var save_game = File.new()
	save_game.open("user://mygarden_garden.save", File.WRITE)
	
	save_game.store_line("Save line")
	
	var save_nodes = get_tree().get_nodes_in_group("Save")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	if !has_save_game():
		return
	
	var save_game = File.new()
	
	var save_nodes = get_tree().get_nodes_in_group("Save")
	for i in save_nodes:
		if i.has_method("get_type") && i.get_type() == "Plant" && i.age <= 1:
			continue
		i.queue_free()

	save_game.open("user://mygarden_garden.save", File.READ)
	var ii = 0
	
	while save_game.get_position() < save_game.get_len():
		if ii == 0:
			ii += 1
			
			var n_data = save_game.get_line()
			
			if n_data != "Save line":
				save_game.close()
				delete_game()
				var err = get_tree().change_scene("res://UI/Title Screen/Title Screen.tscn")
				if err == 0:
					err = 0
				break
			
			continue
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data["filename"]).instance()
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
		
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

	save_game.close()

func delete_game():
	var dir = Directory.new()
	dir.remove("user://mygarden_garden.save")

func has_save_game():
	var save_game = File.new()
	return save_game.file_exists("user://mygarden_garden.save")
