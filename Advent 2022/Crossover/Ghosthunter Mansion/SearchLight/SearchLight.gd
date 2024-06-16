extends Node2D

onready var start_pos = position

export var radius = 256
export var speed = 64

var goal

func _process(delta):
	calc_goal()

func _physics_process(delta):
	if goal != null:
		if (position - goal).distance_to(Vector2(0,0)) < 4:
			goal = null
		else:
			position += position.direction_to(goal)*speed*delta

func calc_goal():
	if goal != null:
		return
	
	var dist = randi()%(2*radius)-radius
	var rot = randi()%365
	
	goal = start_pos + Vector2(dist,0).rotated(deg2rad(rot))
