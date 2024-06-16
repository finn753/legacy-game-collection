extends Node2D

onready var player_container = $Player

const MIN_PLAYER = 2

func _ready():
	Global.scene = "Parkour"
	spawn_unspawned_player()
	spawn_ai()
	Sound.play_random_music()

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
			var nai_player = Global.get_ai_player()
			player_container.add_child(nai_player)

remotesync func win(w):
	Global.last_winner = w
	Global.join_stats()

func _on_Goal_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			if get_tree().network_peer != null:
				rpc("win",body.nickname)
			else:
				win(body.nickname)
