extends Area2D

func _ready():
	gravity_vec = gravity_vec.rotated(deg2rad(rotation_degrees))
