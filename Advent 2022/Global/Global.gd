extends Node

signal blocks_switched
signal reset
signal coin_collected
signal abilities_changed(ability)

signal time_changed
var time = 0

signal in_light_changed

var entered_lights = []

var in_light = false

onready var datetime = OS.get_datetime()
onready var month = datetime["month"]
onready var day = datetime["day"]

const VERSION = "1.3.2-24"
var playable_days = 24

var cheat_progress = false
var cheat_sheet = {
	"climb": 5,
	"double_jump": 11,
	"glide": 19,
	"gravity": 0
	}

var ability = []

var max_coins = 0
var current_coins = 0

var text_box = ""

var player

var block_switch = true

var last_level = 0
var current_level = 0

var overworld_spawn

func _ready():
	if OS.is_debug_build():
		month = 12
		day = 24
		playable_days = 24
		Global.delete_game()
		cheat_progress = true
	
	Global.load_game()

func save_game():
	var save_dict = {
		"ability": ability
	}
	
	var file = File.new()
	file.open("user://advent2022.save", File.WRITE)
	file.store_var(save_dict)
	file.close()

func load_game():
	var save_data
	var file = File.new()
	
	if !file.file_exists("user://advent2022.save"):
		save_game()
	
	var err = file.open("user://advent2022.save", File.READ)
	if err == OK:
		save_data = file.get_var()
	file.close()
	
	if save_data != null:
		for k in save_data.keys():
			if k == "":
				continue
			set(k,save_data[k])

func set_time(t):
	time = t
	emit_signal("time_changed")
	print(t)

func delete_game():
	var dir = Directory.new()
	dir.remove("user://advent2022.save")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func add_ability(a):
	if !ability.has(a):
		ability.append(a)
		emit_signal("abilities_changed", a)

func has_ability(a):
	if ability.has(a):
		return true
	
	if OS.is_debug_build():
		if cheat_progress:
			if OS.get_datetime()["day"] >= cheat_sheet[a]-2:
				return true
			return false
	
	if cheat_progress:
		if day >= cheat_sheet[a]:
			return true
	
	return false

func init_coin():
	max_coins += 1

func collect_coin():
	current_coins += 1
	emit_signal("coin_collected")

func switch_blocks():
	block_switch = !block_switch
	emit_signal("blocks_switched")

func change_level(l):
	print("Last: " + str(last_level))
	print("Current: " + str(current_level))
	print("Next: " + str(l))
	
	Input.action_release("jump")
	
	if l == 0:
		last_level = current_level
		current_level = l
		
		get_tree().change_scene("res://World/World.tscn")
		return
	
	if last_level != l:
		current_coins = 0
	
	last_level = current_level
	current_level = l
	
	get_tree().change_scene("res://Level/" + str(l) + "/" + str(l) + ".tscn")

func restart_game():
	entered_lights = []
	in_light = false
	block_switch = true
	text_box = ""
	set_time(0)
	
	emit_signal("reset")
	#var _error = get_tree().reload_current_scene()

func add_in_light(n):
	if !entered_lights.has(n):
		entered_lights.append(n)
		update_in_light()

func remove_in_light(n):
	entered_lights.erase(n)
	update_in_light()

func update_in_light():
	var n = false
	
	if !entered_lights.empty():
		n = true
	
	if n != in_light:
		in_light = n
		emit_signal("in_light_changed")
