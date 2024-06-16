extends AnimatedSprite

onready var area = $Area2D

export var boundary_left = Vector2(0,0)
export var boundary_right = Vector2(512,320)
export var field = Vector2(128,64)
export var min_move = Vector2(16,16)

var color = 5

var destination
var speed = 40
var desired_places = []

var disappearing = false
var delete = false

var has_ai = false

func _ready():
	Global.connect("night",self,"disappear")
	material.set_shader_param("C3",Vars.COLOR_COMBOS[color][1])
	material.set_shader_param("C5",Vars.COLOR_COMBOS[color][0])
	
	if randi()%2 == 0:
		has_ai = true
	else:
		area.queue_free()

func _process(delta):
	if !disappearing:
		set_destination()
	move(delta)

func set_destination():
	if destination != null || position == null:
		return
	
	if delete:
		queue_free()
	
	destination = Vector2(0,0)
	
	if position.x < boundary_left.x:
		destination.x = boundary_left.x + field.x
	elif position.x > boundary_right.x:
		destination.x = boundary_right.x - field.x
	
	if position.y < boundary_left.y:
		destination.y = boundary_left.y + field.y
	elif position.y > boundary_right.y:
		destination.y = boundary_right.y - field.y
	
	if destination == Vector2(0,0) && desired_places.size() >= 1:
		var chance = 2
		if desired_places.size() <= 2:
			chance = 3
		if randi()%chance == 0:
			destination = desired_places[randi()%desired_places.size()]
	
	if destination.x == 0:
		destination.x = position.x + randi()%int(field.x*2) - field.x - 16
		if destination.x >= 0:
			destination.x += min_move.x
		else:
			destination.x -= min_move.x
	if destination.y == 0:
		destination.y = position.y + randi()%int(field.y*2) - field.y - 16
		if destination.y >= 0:
			destination.y += min_move.y
		else:
			destination.y -= min_move.y

func move(delta = 1/60):
	if destination == null:
		return
	
	var vec = destination - position
	
	if vec.x < 0:
		flip_h = true
	elif vec.x > 0:
		flip_h = false
	
	if abs(vec.x) < 1*speed*delta:
		vec.x = 0
		position.x = destination.x
	
	if abs(vec.y) < 1*speed*delta:
		vec.y = 0
		position.y = destination.y
	
	if vec == Vector2(0,0):
		destination = null
		return
	
	if abs(vec.x) > abs(vec.y):
		if vec.x < 0:
			position.x -= speed * delta
		elif vec.x > 0:
			position.x += speed * delta
	else:
		if vec.y < 0:
			position.y -= speed * delta
		elif vec.y > 0:
			position.y += speed * delta

func disappear():
	disappearing = true
	destination = null
	set_destination()
	delete = true
	
	if randi()%2 == 0: #X
		if randi()%2 == 0: #Left
			destination.x = boundary_left.x
			destination -= field * 3
		else: #Right
			destination.x = boundary_right.x
			destination += field * 3
	else: #X
		if randi()%2 == 0: #Left
			destination.y = boundary_left.y
			destination -= field * 3
		else: #Right
			destination.y = boundary_right.y
			destination += field * 3
	
	disappearing = false

func _on_Area2D_area_entered(area):
	if check_plant(area) > 1:
		var plpos = get_plant_pos(area)
		
		if plpos.x < boundary_left.x || plpos.x > boundary_right.x || plpos.y < boundary_left.y || plpos.y > boundary_right.y:
			return
		
		if plpos in desired_places:
			return
		else:
			desired_places.push_back(plpos)

func _on_Area2D_area_exited(area):
	if check_plant(area) > 1:
		var idx = desired_places.find(get_plant_pos(area))
		if idx != -1:
			desired_places.remove(idx)

func get_plant_pos(area):
	var b = area.get_parent().get_parent().get_parent()
	return b.grid.grid_pos

func check_plant(area):
	var result = 0
	var b = area.get_parent().get_parent().get_parent()
	if b.has_method("is_plant"):
		result += 1
		if b.color == color:
			result += 1
	return result
