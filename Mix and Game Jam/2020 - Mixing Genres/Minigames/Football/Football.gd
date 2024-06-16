extends Node2D

onready var player_container = $Player
onready var l_score = $UI/Score
onready var ball = $Field/Ball

const MIN_PLAYER = 2

var max_goals = 3

var last_team = false

var start_pos = [Vector2(-640,0),Vector2(640,0)]
var score = [0,0]
var team_name = ["",""]

func _ready():
	Global.scene = "Football"
	
	spawn_unspawned_player()
	spawn_ai()
	Sound.play_random_music()

func _physics_process(delta):
	spawn_unspawned_player()
	set_ai_target()

func set_ai_target():
	for p in player_container.get_children():
		if p.has_method("get_type"):
			if p.type == "Player":
				if p.control == "ai":
					var ctarget = ball.position
					
					if p.team == 0:
						if ball.position.x < p.position.x:
							ctarget = start_pos[p.team]
					
					if p.team == 1:
						if ball.position.x > p.position.x:
							ctarget = start_pos[p.team]
					
					if ball.position.x <= -725 || ball.position.x >= 725 || ball.position.y <= -410 || ball.position.y >= 410:
						ctarget = start_pos[p.team]
					
					if ball.position.y <= -485 || ball.position.y >= 485 || ball.position.x <= -800 || ball.position.x >= 800:
						ball.teleport = ball.position/1.5
					
					p.target = ctarget

func spawn_player(p):
	var n_player = p.duplicate()
	
	if !last_team:
		n_player.team = 0
	else:
		n_player.team = 1
	last_team = !last_team
	
	if team_name[n_player.team] == "":
		team_name[n_player.team] = n_player.nickname
	else:
		team_name[n_player.team] = team_name[n_player.team] + " and " + n_player.nickname
	
	n_player.position = start_pos[n_player.team]
	
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

func respawn():
	for p in player_container.get_children():
		p.teleport = start_pos[p.team]
		if p.control == "ai":
			p.ai_pause = true
			p.cooldown.start()
	
	ball.teleport = Vector2(0,0)

remotesync func goal(t):
	Sound.play_sound("Point")
	score[t] += 1
	l_score.text = String(score[0]) + ":" + String(score[1])
	respawn()
	
	if score[t] >= max_goals:
		if get_tree().network_peer != null:
			rpc("win",t)
		else:
			win(t)

remotesync func win(t):
	Global.last_winner = team_name[t]
	Global.join_stats()

func _on_Goal0_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Ball":
			if get_tree().network_peer != null:
				rpc("goal",1)
			else:
				goal(1)

func _on_Goal1_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Ball":
			if get_tree().network_peer != null:
				rpc("goal",0)
			else:
				goal(0)
