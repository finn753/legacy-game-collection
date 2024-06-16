extends Node2D

export(NodePath) var player_path
onready var player = get_node(player_path)

var mail_left = 0

export var max_mail = 4

func _process(delta):
	mail_left = Global.max_coins - Global.current_coins
	max_mail = Global.max_coins
	
	if mail_left >= max_mail:
		set_stats(8,50,0.15,0.15)
	elif mail_left == max_mail - 1:
		set_stats(20,75,0.225,0.225)
	elif mail_left == max_mail - 2:
		set_stats(32,100,0.25,0.3)
	elif mail_left == max_mail - 3:
		set_stats(40,150,0.3,0.35)
	else:
		set_stats(44,200,0.3,0.35)
	
func set_stats(h,s,u,d):
	player.speed = s
	player.jump_velocity = ((2.0 * h) / u) * -1.0
	player.jump_gravity = ((-2.0 * h) / (u * u)) * -1.0
	player.fall_gravity = ((-2.0 * h) / (d * d)) * -1.0
