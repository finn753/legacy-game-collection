extends Node2D

onready var tilemap = $TileMap
onready var objects = $Objects
onready var canvas = $CanvasModulate
onready var player = $Player

enum door_state {NONE,UNLOCKED,LOCKED}

const SPAWN_POS = {
	-1: Vector2(8,72),
	1: Vector2(264,72),
	-10: Vector2(136,136),
	10: Vector2(136,8)
	}

var room_data = {
	"doors": {
		-1: door_state.UNLOCKED,
		1: door_state.UNLOCKED,
		-10: door_state.UNLOCKED,
		10: door_state.UNLOCKED
	}
}

func _ready():
	print(Global.current_room)
	build_room()

func read_room_data():
	pass

func build_room():
	#Player
	var t_dir = Global.old_room - Global.current_room
	player.position = SPAWN_POS[t_dir]
	print(t_dir)
	
	
	#Doors
	var s = str(Global.current_room)
	
	if s.begins_with("1"):
		room_data["doors"][-10] = door_state.NONE
	
	if s.begins_with("9"):
		room_data["doors"][10] = door_state.NONE
	
	if s.ends_with("1"):
		room_data["doors"][-1] = door_state.NONE
	
	if s.ends_with("9"):
		room_data["doors"][1] = door_state.NONE
	
	for k in room_data["doors"].keys():
		if room_data["doors"][k] == door_state.NONE:
			block_door(k)

func block_door(d):
	if d == -1:
		for x in range(-2,-1+1):
			for y in range(2,4+1):
				tilemap.set_cell(x,y,2)
	elif d == 1:
		for x in range(17,18+1):
			for y in range(2,4+1):
				tilemap.set_cell(x,y,2)
	elif d == 10:
		tilemap.set_cell(8,-1,1)
	elif d == -10:
		tilemap.set_cell(8,9,2)
		tilemap.set_cell(8,10,2)
