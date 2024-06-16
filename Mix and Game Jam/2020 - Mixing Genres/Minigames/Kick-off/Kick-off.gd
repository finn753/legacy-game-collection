extends Node2D

onready var player_container = $Player
onready var tilemap = $TileMap
onready var indicator = $Indicator

export var started = false

const MIN_PLAYER = 2

var collapse = -3

func _ready():
	Global.scene = "Kick-off"
	spawn_unspawned_player()
	spawn_ai()
	Sound.play_random_music()

func _physics_process(delta):
	if started:
		check_win()
		check_death()

func check_win():
	if player_container.get_child_count() == 1:
		for p in player_container.get_children():
			if get_tree().network_peer != null:
				rpc("win",p.nickname)
			else:
				win(p.nickname)
	elif player_container.get_child_count() == 0:
		if get_tree().network_peer != null:
			rpc("win","Nobody")
		else:
			win("Nobody")

remotesync func win(w):
	Global.last_winner = w
	Global.join_stats()

func check_death():
	for p in player_container.get_children():
		if tilemap.get_cellv(tilemap.world_to_map(p.position/4)) == -1:
			if get_tree().network_peer != null:
				rpc('death',p)
			else:
				death(p)

remotesync func death(p):
	Sound.play_sound("Death")
	p.queue_free()

func start_game():
	started = true

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

func despawn_disconnected_player():
	for p in player_container.get_children():
		var cdisconnected = true
		
		for sp in Global.get_all_player():
			if p.id == sp.id:
				cdisconnected = false
		
		if cdisconnected:
			p.queue_free()

func spawn_ai():
	if MIN_PLAYER - player_container.get_child_count() > 0:
		for a in range(MIN_PLAYER - player_container.get_child_count()):
			spawn_player(Global.get_ai_player())


func _on_Collapse_timeout():
	for t in tilemap.get_used_cells():
		if t.x <= collapse || t.y <= collapse:
			tilemap.set_cellv(t,14)
		Sound.play_sound("PSelect")
		indicator.start()

func _on_Indicator_timeout():
	Sound.play_sound("PRemove")
	for t in tilemap.get_used_cells_by_id(14):
		tilemap.set_cellv(t,-1)
	collapse += 1
