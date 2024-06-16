extends Node

const VERSION = "1.0a"

var menu = true

var player_res = preload("res://Entity/Player/Player.tscn")
var ai_res = preload("res://Entity/Player/Player.tscn")
var sprites = ["Ghost","Donut","Stranger","Pinata"]
var controls = ["wasd","arrow","8462"]

var scene = ""
var local_data = {
	"name": "",
	"position": Vector2(0,0),
	"control": "wasd",
	"character": 0,
	"is_master": true
	}
var player_data = {}

var last_winner = ""

func _ready():
	if player_data.hash() == {}.hash():
		add_player(1,local_data)

func join_lobby():
	get_tree().change_scene("World/Lobby/Lobby.tscn")

func join_minigame(m):
	if get_tree().network_peer != null:
		get_tree().set_refuse_new_network_connections(true)
	if m == "Coming Soon":
		return
	
	Sound.play_sound("Start")
	get_tree().change_scene("Minigames/" + m + "/" + m + ".tscn")

func join_stats():
	get_tree().change_scene("UI/Stats/Stats.tscn")


func add_player(id: int, data):
	player_data[id] = data
	#print("Added player: " + String(data))

func init_player(id,is_master):
	player_data[id]["is_master"] = is_master

func get_player(id):
	var n_player = player_res.instance()
	n_player.id = id
	n_player.nickname = player_data[id].name
	n_player.control = player_data[id].control
	n_player.character = player_data[id].character
	n_player.is_master = player_data[id].is_master
	
	return n_player.duplicate()

func get_all_player():
	var cap = []
	
	for p in player_data.keys():
		if player_data[p]["control"] != "server":
			cap.push_back(get_player(p))
	
	return cap

func get_ai_player():
	var nai_player = ai_res.instance()
	
	nai_player.id = -1
	nai_player.nickname = "Com"
	nai_player.control = "ai"
	nai_player.is_master = true
	nai_player.character = randi()%sprites.size()
	
	return nai_player
