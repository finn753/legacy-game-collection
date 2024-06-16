extends Node

export(NodePath) var player_path

onready var player = get_node(player_path)

var air_time = 0.0
var move = 0

func _process(delta):
	check_player(delta)
	point_update()

func check_player(delta = 1/60):
	if player.is_on_floor():
		if air_time > 0:
			air_time = 0
	elif player.state == player.STATES.Climb:
		if air_time > 0:
			air_time -= delta*7
	else:
		if air_time < 10:
			air_time = 10
		else:
			air_time += delta*20
	
	if round(player.velocity.x) == 0:
		move = 0
	else:
		move = 10

func point_update():
	if Global.current_coins < 100:
		Global.current_coins = round(air_time) + move
