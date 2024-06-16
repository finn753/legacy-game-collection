extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content

onready var sprite = content.get_node("Sprite")
onready var particle = content.get_node("Particles2D")
onready var particle2 = content.get_node("Particles2D2")

var watering = false
var moving = false

var start_pos

func _ready():
	start_pos = position
	grid.set_grid_pos(position)
	position = Vector2(0,0)
	
	grid.connect("on_move",self,"on_move")
	grid.connect("on_move_ended",self,"on_move_ended")
	
	pickup_ended()
	
	Global.connect("new_day",self,"on_new_day")

func _process(delta):
	if watering && moving:
		water()

func water():
	var c = move.get_collider(Vector2(0,24),Vector2(8,0))
	
	if c == null:
		return
	
	c = c.get_parent()
	
	if c.has_method("get_watered"):
		c.get_watered()

func on_move():
	water()
	moving = true

func on_move_ended():
	water()
	moving = false

func pickup_started():
	watering = true
	moving = false
	sprite.rotation_degrees = 45
	particle.emitting = true
	particle2.emitting = true

func pickup_ended():
	watering = false
	moving = false
	sprite.rotation_degrees = 0
	particle.emitting = false
	particle2.emitting = false

func collision(step: Vector2, colliding = false):
	pass

func on_new_day():
	grid.set_grid_pos(start_pos)

func is_watering_can():
	return true

func is_tool():
	return true
