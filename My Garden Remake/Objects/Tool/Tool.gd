extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content

func _ready():
	grid.set_grid_pos(position)
	position = Vector2(0,0)

func pickup_started():
	print("Pickup S")
	pass

func pickup_ended():
	print("Pickup E")
	pass

func collision(step: Vector2, colliding = false):
	print("Collision")
	pass
