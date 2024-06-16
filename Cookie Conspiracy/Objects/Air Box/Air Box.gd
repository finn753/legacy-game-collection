extends RigidBody2D

onready var area = $Area2D

func _ready():
	area.gravity_vec = area.gravity_vec.rotated(deg2rad(rotation_degrees))
