extends Node2D

onready var active = true

onready var grid = $GridObject
onready var sprite = $GridObject/Sprite
onready var area = $Area2D
onready var tween = $Tween

var picked_child = null
var available_move_child = null
var is_moving = false
var buffer_pickup = false

func _ready():
	grid.set_grid_pos(position)
	area.position = grid.grid_pos
	position = Vector2(0,0)
	Global.cursor_pos = grid.grid_pos
	
	grid.tween.connect("tween_all_completed",self,"move_completed")

func _process(_delta):
	if Global.sleeping:
		if picked_child != null:
			if !is_moving && picked_child.end_pickup():
				picked_child = null
				visible = false
				return
		else:
			visible = false
			return
	
	visible = true
	
	if !active:
		return
	
	Global.cursor_pos = grid.grid_pos
	
	if grid.set_grid_pos(get_global_mouse_position()):
		available_move_child = null
		area.set_position(grid.grid_pos)
		is_moving = true
	if !is_moving:
		if picked_child != null:
			if Input.is_action_just_pressed("action") || buffer_pickup:
				if picked_child.end_pickup():
					available_move_child = picked_child
					picked_child = null
		elif available_move_child != null:
			if !available_move_child.has_method("pickup"):
				available_move_child = null
			elif Input.is_action_just_pressed("action") || buffer_pickup:
				picked_child = available_move_child
				available_move_child = null
				picked_child.pickup(self)
		buffer_pickup = false
	else:
		if Input.is_action_just_pressed("action"):
			buffer_pickup = true
	
	var nc1 = Color(0.17,0.21,0.3,1.0)
	var nc3 = Color(0.87,0.88,0.91,1.0)
	
	var oc1 = sprite.material.get_shader_param("C1")
	var oc3 = sprite.material.get_shader_param("C3")
	
	var nscale = Vector2(1,1)
	
	sprite.animation = "default"
	
	if picked_child != null:
		if picked_child.placement_water && picked_child.get_parent().has_method("water"):
			nc1 = Color(0.3,0.41,0.52,1.0)
			nc3 = Color(0.31,0.64,0.72,1.0)
		elif picked_child.placement == picked_child.space.VALID:
			nc1 = Color(0.41,0.44,0.6,1.0)
			nc3 = Color(0.64,0.65,0.76,1.0)
		elif picked_child.placement == picked_child.space.STACK:
			nc1 = Color(1.0,0.54,0.2,1.0)
			nc3 = Color(0.94,0.71,0.25,1.0)
		elif picked_child.placement == picked_child.space.OCCUPIED:
			nc1 = Color(0.68,0.18,0.27,1.0)
			nc3 = Color(0.9,0.27,0.22,1.0)
			sprite.animation = "invalid"
		elif picked_child.placement == picked_child.space.OUTSIDE:
			nc1 = Color(1.0,0.54,0.2,1.0)
			nc3 = Color(0.94,0.71,0.25,1.0)
	elif available_move_child != null:
		nc1 = Color(1.0,0.54,0.2,1.0)
		nc3 = Color(0.94,0.71,0.25,1.0)
		nscale = Vector2(1.25,1.25)
	
	tween.remove_all()
	tween.interpolate_property(sprite.material,"shader_param/C1",oc1,nc1,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(sprite.material,"shader_param/C3",oc3,nc3,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(sprite,"scale",null,nscale,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
	#sprite.material.set_shader_param("C1",nc1)
	#sprite.material.set_shader_param("C3",nc3)

func _on_Area2D_area_entered(_a):
	check_available_move_child()

func check_available_move_child():
	available_move_child = null
	
	for a in area.get_overlapping_areas():
		var b = a.get_parent().get_parent()
		if b.has_method("is_movable_object") && b.pickable:
			available_move_child = b

func move_completed():
	is_moving = false
	check_available_move_child()

func is_plant_mover():
	return true
