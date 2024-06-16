extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content

func _ready():
	grid.set_grid_pos(position)
	position = Vector2(0,0)
