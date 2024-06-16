extends Node2D

onready var transition = $UI/Transition
onready var tilemap = $WorldMap

export var level = 6

func _ready():
	Global.text_box = ""
	Global.current_level = level
	
	Global.max_coins = 9
	
	calculate_switch_blocks()
	
	var _error = Global.connect("blocks_switched",self,"calculate_switch_blocks")
	_error = Global.connect("reset",self,"reset")
	
	transition.connect("closed",self,"is_closed")
	transition.open()

func reset():
	$Music.play()
	transition.force_close()
	transition.open()
	Global.set_time(0)
	print(Global.time)

func calculate_switch_blocks():
	if Global.block_switch:
		#4 to 2
		for b in tilemap.get_used_cells_by_id(4):
			tilemap.set_cellv(b,2)
		#3 to 5
		for b in tilemap.get_used_cells_by_id(3):
			tilemap.set_cellv(b,5)
	else:
		#2 to 4
		for b in tilemap.get_used_cells_by_id(2):
			tilemap.set_cellv(b,4)
		#5 to 3
		for b in tilemap.get_used_cells_by_id(5):
			tilemap.set_cellv(b,3)

func is_closed():
	print("Closed")
	if Global.max_coins == Global.current_coins:
		var _error = get_tree().change_scene("res://World/World.tscn")

func _on_Music_finished():
	transition.close(5.0)
