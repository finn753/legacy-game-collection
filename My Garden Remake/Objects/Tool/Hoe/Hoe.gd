extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content

onready var sprite = content.get_node("AnimatedSprite")

export(NodePath) var tilemap_path

export var tile_mapping = {
		0: 1,
		1: 0
	}

var tilemap

var start_pos

func _ready():
	start_pos = position
	grid.set_grid_pos(position)
	position = Vector2(0,0)
	tilemap = get_node(tilemap_path)
	
	Global.connect("new_day",self,"on_new_day")

func pickup_started():
	pass

func pickup_ended():
	pass

func collision(step: Vector2, colliding = false):
	if colliding:
		return
	
	var target_pos = grid.pixel2grid(grid.position)
	var map_pos = tilemap.world_to_map(target_pos)
	var current_tile = tilemap.get_cellv(map_pos)
	
	if step.x < 0:
		sprite.animation = "left"
	elif step.x > 0:
		sprite.animation = "right"
	elif step.y < 0:
		sprite.animation = "up"
	elif step.y > 0:
		sprite.animation = "down"
	
	if current_tile in tile_mapping.keys():
		tilemap.set_cellv(map_pos, tile_mapping[current_tile])
		tilemap.update_bitmask_area(map_pos)

func on_new_day():
	grid.set_grid_pos(start_pos)
