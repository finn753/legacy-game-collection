extends Node2D

onready var player_container = $Player
onready var b_player_container = $Menu/Settings/Player
onready var version = $Menu/Version

onready var menu = $Menu/Menu
onready var settings = $Menu/Settings

var b_player_res = preload("res://UI/Player Settings/Player Settings.tscn")

func _ready():
	Global.scene = "Lobby"
	
	menu.visible = Global.menu
	settings.visible = !Global.menu
	Motion.ui_stop = Global.menu
	
	version.text = "Version " + Global.VERSION
	
	spawn_unspawned_player()
	
	if get_tree().network_peer != null:
		get_tree().set_refuse_new_network_connections(false)
	
	Sound.play_music("Town")

func _process(delta):
	spawn_unspawned_player()
	despawn_disconnected_player()

func spawn_player(p):
	var n_player = p.duplicate()
	n_player.team = null
	n_player.target = null
	player_container.add_child(n_player)

func spawn_unspawned_player():
	for p in Global.get_all_player():
		var cspawned = false
		
		for sp in player_container.get_children():
			if sp.id == p.id:
				cspawned = true
		if !cspawned:
			spawn_player(p)
			if p.is_master:
				var nb_player = b_player_res.instance()
				nb_player.id = p.id
				b_player_container.add_child(nb_player)

func despawn_disconnected_player():
	for p in player_container.get_children():
		var cdisconnected = true
		
		for sp in Global.get_all_player():
			if p.id == sp.id:
				cdisconnected = false
		
		if cdisconnected:
			p.queue_free()

func close_menu():
	Global.menu = false
	menu.visible = Global.menu
	settings.visible = !Global.menu
	Motion.ui_stop = Global.menu


func _on_Play_button_down():
	close_menu()

func _on_Add_Button_button_down():
	Global.add_player(Global.player_data.size()+1,Global.local_data)
	print(String(Global.player_data))


func _on_Join_Local_button_down():
	Net.connect_to_server()

func _on_Create_Local_button_down():
	Net.create_server(Global.local_data["name"])
