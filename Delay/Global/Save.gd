extends Node

const SAFE_VERSION = 1

var highscore = 0
var highscore_points = []

func _ready():
	load_settings()

func save_settings():
	var save_dict = {
		"SAFE_VERSION": SAFE_VERSION,
		"VERSION": Global.VERSION,
		"highscore": highscore,
		"highscore_points": highscore_points,
		"volume_Music": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"volume_Sound": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound"))
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
			if k == "VERSION" || k == "SAFE_VERSION":
				continue
			elif k.begins_with("volume_"):
				var b = k.replace("volume_","")
				var idx = AudioServer.get_bus_index(b)
				AudioServer.set_bus_volume_db(idx,save_data[k])
				continue
			set(k,save_data[k])
