extends Node2D

var mouse_in_window = false

var traps = ["Slime","Boost","Sand","Fire","Oil","Golden Donut","Ice"]
var current_trap = ""
var invert_placement = false

var player_pos = Vector2()

var highscore = 0
var score = 0
var score_changed = false

var screen_size = Vector2()

const VERSION = "2.0"

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	load_game()

func _process(_delta):
	screen_size = get_viewport_rect().size

func _input(event):
	if  event is InputEventMouseMotion:
		mouse_in_window = true
	else:
		if Input.is_action_just_pressed("window"):
			OS.window_fullscreen = !OS.window_fullscreen

func _notification(n):
	match n:
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_in_window = false
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_in_window = true

func add_score(s):
	score += s
	score_changed = true
	if score > highscore:
		highscore = score
		save_game()

func save_game():
	print("Save game")
	
	var save_game = File.new()
	save_game.open("user://donut_seduction.save", File.WRITE)
	
	var save_data = {
		"highscore": highscore,
		"audio_master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
		"audio_sound": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")),
		"audio_music": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
	}
	
	save_game.store_line("Savesys:2.0")
	save_game.store_line(to_json(save_data))
	save_game.close()

func load_game():
	print("Load game")
	
	var save_game = File.new()
	if !save_game.file_exists("user://donut_seduction.save"):
		save_game()
		return
	
	save_game.open("user://donut_seduction.save", File.READ)
	
	var corruped = true
	
	while save_game.get_position() < save_game.get_len():
		var line = save_game.get_line()
		
		if line == "Savesys:2.0":
			corruped = false
			continue
		elif corruped:
			save_game.close()
			save_game()
			return
		
		var save_data = parse_json(line)
		print(save_data)
		highscore = save_data["highscore"]
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),save_data["audio_master"])
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),save_data["audio_sound"])
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),save_data["audio_music"])
	
	save_game.close()

func delete_game():
	pass

func change_scene(scene):
	var err = get_tree().change_scene(scene)
	if err != 0:
		print("change_scene err: " + str(err))
