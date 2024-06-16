extends CanvasLayer

onready var l_timer = $Timer
onready var t_timer = $Timer/Timer
onready var winner = $Winner

onready var player_container = $CenterContainer/Player

func _ready():
	Global.scene = "Stats"
	winner.text = Global.last_winner + " won"
	spawn_unspawned_player()
	Sound.play_music("Stats")

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

func _process(delta):
	l_timer.text = String(ceil(t_timer.time_left))
	spawn_unspawned_player()
	despawn_disconnected_player()

remotesync func join_lobby():
	Global.join_lobby()

func _on_Timer_timeout():
	l_timer.text = "0"
	
	if get_tree().network_peer != null:
		rpc("join_lobby")
	else:
		join_lobby()
