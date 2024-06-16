extends Node2D

signal on_move
signal on_move_ended

onready var tween = $Tween

export var tile_size = Vector2(16,16)
export var grid_offset = Vector2(0,0)
export var object_offset = Vector2(0,0)

export var tween_trans = Tween.TRANS_SINE #Tween.TRANS_BACK
export var tween_ease = Tween.EASE_OUT

var pixel_pos = Vector2()
var grid_pos = Vector2()
var old_grid_pos = Vector2()

func _ready():
	set_grid_pos(position)

func set_grid_pos(pos: Vector2, t_trans = null, t_ease = null):
	pixel_pos = pos
	
	old_grid_pos = grid_pos
	grid_pos = pixel2grid(pos)
	
	if t_trans == null:
		t_trans = tween_trans
	if t_ease == null:
		t_ease = tween_ease
	
	if grid_pos != old_grid_pos:
		tween.interpolate_property(self,"position", null, grid_pos, 0.15, t_trans, t_ease)
		tween.start()
		emit_signal("on_move")
		return true

func pixel2grid(pos: Vector2):
	var p_grid_offset = grid_offset * tile_size
	var p_object_offset = object_offset * tile_size
	
	pos += p_grid_offset
	
	return ((pos / tile_size).floor() * tile_size) - p_grid_offset + p_object_offset

func gridstep2pixel(step: Vector2):
	return pixel2grid(position + gridstep2step(step))

func gridstep2step(step: Vector2):
	return step * tile_size

func is_grid_object():
	return true

func _on_Tween_tween_all_completed():
	emit_signal("on_move_ended")
