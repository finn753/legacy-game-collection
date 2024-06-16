extends Node2D

signal on_move_ended
signal delete

const TYPE = "MovableObject"

onready var grid = $GridObject
onready var area = $GridObject/Area2D
onready var collision = $GridObject/Area2D/CollisionShape2D
onready var raycast = $GridObject/Area2D/RayCast2D

onready var content = $GridObject/Content
onready var content_tween = $GridObject/Content/Tween
onready var content_animation = $GridObject/Content/AnimationPlayer

export var collidable = true
export var walkable = true
export var pushable = false
export var pickable = true
export var stackable = false

var cache_setting

export var is_walker = false
export var is_tool = false
export var is_furniture = false
export var furniture_type = ""

export var override_position = false

export var deletable = false
var delete = false

enum space { VALID, OCCUPIED, STACK, OUTSIDE, WATER }

var pickup_parent = null
var placement = space.VALID
var placement_water = false

var is_moving = false

var last_save_pos = Vector2(0,0)

func _ready():
	if !override_position:
		grid.set_grid_pos(position)
		position = Vector2(0,0)
	
	var shape = RectangleShape2D.new()
	shape.extents = (grid.tile_size / 2) - Vector2(1,1)
	collision.set_deferred("shape",shape)
	
	collision.position = grid.tile_size / 2
	
	for c in get_children():
		if c == grid:
			continue
			
		var nc = c.duplicate()
		if c.has_method("exclude_movable_content"):
			grid.add_child(nc)
		else:
			if nc.get("position") != null:
				nc.position = c.position - content.position
			elif nc.get("rect_position") != null:
				nc.rect_position = c.rect_position - content.position
			content.add_child(nc)
		c.queue_free()

func _process(_delta):
	if pickup_parent != null:
		if grid.set_grid_pos(pickup_parent.grid.grid_pos):
			is_moving = true
		
		placement = space.VALID
		placement_water = false
		
		var c = get_collider(Vector2(0,24),Vector2(8,0))
		
		if c != null && c.has_method("collision"):
			if c.stackable:
				placement = space.STACK
			else:
				placement = space.OCCUPIED
			
			if c.get_parent().has_method("get_watered"):
				placement_water = true
		if content.position == Vector2(8,8):
			content_tween.remove_all()
			content_tween.interpolate_property(content,"position",null,Vector2(8,-16),0.4,Tween.TRANS_BACK,Tween.EASE_OUT)
			content_tween.start()
	else:
		last_save_pos = grid.position
	
func pickup(parent):
	if !pickable:
		return false
	
	pickup_parent = parent
	
	area.set_collision_layer_bit(0,false)
	
	content_tween.remove_all()
	content_tween.interpolate_property(content,"position",null,Vector2(8,-16),0.4,Tween.TRANS_SINE,Tween.EASE_OUT)
	content_tween.start()
	
	if is_tool:
		get_parent().pickup_started()
	
	content.z_index = 1
	
	return true

func end_pickup():
	if placement == space.OCCUPIED:
		content_animation.play("invalid",-1,8.0)
		return false
	
	pickup_parent = null
	
	area.set_collision_layer_bit(0,true)
	
	content_animation.stop()
	content_tween.remove_all()
	content_tween.interpolate_property(content,"position",null,Vector2(8,8),0.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	content_tween.start()
	
	if is_tool:
		get_parent().pickup_ended()
	
	last_save_pos = grid.grid_pos
	
	$GridObject/AudioStreamPlayer2D.play()
	
	return true

func collide(step: Vector2):
	raycast.position = step / 2 + Vector2(8,8)
	raycast.cast_to = step / 2
	raycast.enabled = true
	raycast.force_raycast_update()
	
	if !raycast.is_colliding():
		raycast.enabled = false
		return false
	
	var c = raycast.get_collider().get_parent().get_parent()
	raycast.enabled = false
	
	if !c.has_method("collision"):
		return false
	
	return c.collision(step,is_walker)

func get_collider(step: Vector2, from = null):
	if from == null:
		raycast.position = step / 2 + Vector2(8,8)
	else:
		raycast.position = from
	
	raycast.cast_to = step / 2
	raycast.enabled = true
	raycast.force_raycast_update()

	if !raycast.is_colliding():
		raycast.enabled = false
		return

	var c = raycast.get_collider().get_parent().get_parent()
	raycast.enabled = false
	return c

#func check_collision(step: Vector2, from = null):
#	if from == null:
#		raycast.position = step / 2 + Vector2(8,8)
#	else:
#		raycast.position = from
#	raycast.cast_to = step / 2
#	raycast.enabled = true
#	raycast.force_raycast_update()
#
#	if !raycast.is_colliding():
#		raycast.enabled = false
#		return false
#
#	var c = raycast.get_collider().get_parent().get_parent()
#	raycast.enabled = false
#
#	if !c.has_method("collision"):
#		return false
#
#	return true

func collision(step: Vector2, collider_is_walker = false):
	if collider_is_walker && walkable:
		if is_furniture:
			return get_parent().collision(step,false,true)
		if is_tool:
			get_parent().collision(step,false)
		return false
	
	if !collidable:
		if is_furniture:
			return get_parent().collision(step,false)
		if is_tool:
			get_parent().collision(step,false)
		return false
	
	if !pushable:
		if is_furniture:
			return get_parent().collision(step,true)
		if is_tool:
			get_parent().collision(step,true)
		return true
	
	if !collide(step):
		collision_move(step)
		if is_furniture:
			return get_parent().collision(step,false)
		if is_tool:
			get_parent().collision(step,false)
		return false
	
	if is_furniture:
		return get_parent().collision(step,true)
	
	if is_tool:
		get_parent().collision(step,true)
	return true

func collision_move(step):
	if grid.set_grid_pos(grid.position + step):
		is_moving = true
	last_save_pos = grid.grid_pos

func get_type():
	return TYPE

func is_movable_object():
	return true

func animated_delete():
	emit_signal("delete")
	delete = true
	
	if pickup_parent != null:
		pickup_parent.end_pickup()
		pickup_parent.picked_child = null
	
	content_tween.interpolate_property(content,"scale",null,Vector2(0,0),1.0,Tween.TRANS_BACK,Tween.EASE_IN)
	content_tween.start()

func _on_Tween_tween_all_completed():
	if delete:
		get_parent().queue_free()
	
	is_moving = false
	
	if pickup_parent != null:
		content_animation.play("hover")
	else:
		content.z_index = 0
	
	if pickup_parent == null && content.position != Vector2(8,8):
		end_pickup()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "invalid":
		content_animation.play("hover")
