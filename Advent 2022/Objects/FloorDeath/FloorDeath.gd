extends ColorRect

export(NodePath) var player_path
export var countdown = 3.0
export var buffer = 0.2

onready var player: KinematicBody2D = get_node(player_path)

var time = 0
var delay = 0.5

func _ready():
	visible = true
	rect_scale.x = 0
	
	Global.connect("reset",self,"reset")

func _process(delta):
	if delay > 0:
		delay -= delta
	
	if player.is_on_floor() && delay <= 0:
		time += delta
	else:
		time = 0
	
	if time > countdown + buffer:
		$AudioStreamPlayer.play()
		player.death()
	
	var p = time/countdown
	
	if p < rect_scale.x:
		rect_scale.x = (15*rect_scale.x + p)/16
	else:
		rect_scale.x = p

func reset():
	delay = 0.5
	time = 0
	rect_scale.x = 0
