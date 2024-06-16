extends Node2D

export var weight = 100
export var mirror_direction = false

onready var sensor = $Sensor
onready var bottom = $Sensor/Bottom
onready var top = $Sensor/Top
onready var left = $Sensor/Left
onready var right = $Sensor/Right

func _physics_process(delta):
	rotation += calc_wind_rot() * delta
	sensor.rotation = -rotation

func calc_wind_rot():
	var wind = 0
	
	for a in top.get_overlapping_areas():
		if a.has_method("get_wind_vector"):
			wind += a.get_wind_vector().x
	
	for a in right.get_overlapping_areas():
		if a.has_method("get_wind_vector"):
			wind += a.get_wind_vector().y
	
	if wind == 0:
		for a in bottom.get_overlapping_areas():
			if a.has_method("get_wind_vector"):
				wind -= a.get_wind_vector().x
		
		for a in left.get_overlapping_areas():
			if a.has_method("get_wind_vector"):
				wind -= a.get_wind_vector().y
	
	if mirror_direction:
		wind *= -1
	
	return wind/weight
