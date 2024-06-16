extends Node2D

signal on_watered
signal new_day

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content
onready var tween = $Tween

onready var sprite = content.get_node("AnimatedSprite")
onready var reproduction = grid.get_node("Reproduction")
onready var watered_sprite = content.get_node("Watered")

export var age = 0
export var species = 0
export var color = 5
export var color_mutation_chance = 4
export var species_mutation_chance = 4

var is_full_age = false
var watered = false
var reproduction_cooldown = 0

func _ready():
	move.connect("delete",self,"on_delete")
	
	if Global.color_stats.has(color):
		Global.color_stats[color] += 1
	else:
		Global.color_stats[color] = 1
	
	if Global.species_stats.has(species):
		Global.species_stats[species] += 1
	else:
		Global.species_stats[species] = 1
	
	grid.set_grid_pos(position)
	move.last_save_pos = grid.grid_pos
	position = Vector2(0,0)
	
	Global.connect("new_day",self,"new_day")
	
	sprite.scale = Vector2(0,0)
	watered_sprite.visible = false
	
	for r in reproduction.get_children():
		r.set_parent(self)
	
	#reload()
	$Reload.start()
	#displace()

func on_delete():
	if Global.color_stats.has(color):
		Global.color_stats[color] -= 1
	else:
		Global.color_stats[color] = 0
	
	if Global.species_stats.has(species):
		Global.species_stats[species] -= 1
	else:
		Global.species_stats[species] = 0

func displace():
	sprite.offset.x = randi()%3-1
	sprite.offset.y = randi()%3-1

func reset_displace():
	sprite.offset = Vector2(0,0)

func initialize(parents):
	if parents == null || parents == []:
		queue_free()
	
	randomize()
	
	age = 0
	#age = 15 #TODO Remove
	watered = false
	
	var l_colors = []
	var l_species = []
	
	for p in parents:
		l_colors.append(p.parent.color)
		l_species.append(p.parent.species)
	
	var c_color = l_colors[randi()%l_colors.size()]
	var c_species = l_species[randi()%l_species.size()]
	
	#MUTATION
	#Mutate Color
	if randi()%color_mutation_chance == 0:
		var step = randi()%2
		if step == 0:
			step = -1
			
		c_color += step
		
		if c_color < 0:
			c_color += Vars.COLOR_COMBOS.size() - 1
		elif c_color >= Vars.COLOR_COMBOS.size():
			c_color -= Vars.COLOR_COMBOS.size() - 1
		
	elif randi()%species_mutation_chance == 0:
		var step = randi()%2
		if step == 0:
			step = -1
			
		c_species += step
		
		if c_species < 0:
			c_species += Vars.SPECIES.size() - 1
		elif c_species >= Vars.SPECIES.size():
			c_species -= Vars.SPECIES.size() - 1
	
	#Guard Values
	c_color = clamp(c_color,0,Vars.COLOR_COMBOS.size() - 1)
	c_species = clamp(c_species,0,Vars.SPECIES.size() - 1)
	
	# Set Values
	color = c_color
	species = c_species
	reload()

func new_day():
	reproduce()
	grow()
	reload()
	
func grow():
	if watered:
		Global.flowers_watered += 1
		watered = false
		age += 1
	else:
		Global.flowers_not_watered += 1

func reproduce():
	emit_signal("new_day")
	if reproduction_cooldown > 0:
		reproduction_cooldown -= 1

func get_watered():
	if !watered:
		watered = true
		emit_signal("on_watered")
		reload()

func can_reproduce():
	#return true
	return is_full_age && watered && reproduction_cooldown <= 0

func reload():
	if sprite == null:
		return
	sprite.animation = Vars.SPECIES[species]
	var frame_count = sprite.frames.get_frame_count(sprite.animation)
	
	sprite.material.set_shader_param("C1",Vars.COLOR_COMBOS[color][0])
	sprite.material.set_shader_param("C2",Vars.COLOR_COMBOS[color][1])
	
	if age < frame_count - 1:
		sprite.frame = age
		is_full_age = false
	else:
		sprite.frame = frame_count - 1
		is_full_age = true
	
	if watered_sprite.visible != watered:
		var nscale = Vector2(1,1)
		if watered:
			watered_sprite.scale = Vector2(0,0)
			tween.interpolate_property(watered_sprite,"scale",null,Vector2(1,1),1.0,Tween.TRANS_BACK,Tween.EASE_OUT)
			nscale = Vector2(1.1,1.1)
		
		if nscale != sprite.scale:
			tween.interpolate_property(sprite,"scale",null,nscale,1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		
		tween.start()
		
		watered_sprite.visible = watered

func save():
	var save_dict = {
		"age": age,
		"species": species,
		"color": color,
		"watered": watered,
		"reproduction_cooldown": reproduction_cooldown,
		"pos_x": move.last_save_pos.x,
		"pos_y": move.last_save_pos.y,
		"parent": get_parent().get_path()
	}
	
	return save_dict

func load_state(s):
	grid.set_grid_pos(Vector2(s["pos_x"],s["pos_y"]))
	
	for k in s.keys():
		if k == "pos_x" || k == "pos_y" || k == "parent":
			continue
		set(k,s[k])
	
	reload()

func _on_Reload_timeout():
	reload()
	tween.interpolate_property(sprite,"scale",null,Vector2(1,1),0.4,Tween.TRANS_BACK,Tween.EASE_OUT)
	tween.start()
	move.last_save_pos = grid.grid_pos

func is_plant():
	return true
