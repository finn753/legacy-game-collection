extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var tween = $Tween
onready var content = $MovableObject/GridObject/Content

onready var sprite = content.get_node("AnimatedSprite")

export var res_path = "res://Objects/Decoration/"

var initialize = false

func _ready():
	grid.set_grid_pos(position)
	position = Vector2(0,0)
	
	sprite.scale = Vector2(0,0)
	
	$Timer.start()

func initialize():
	var animations = sprite.frames.get_animation_names()
	sprite.set_animation(animations[randi()%animations.size()])
	sprite.flip_h = randi()%2 == 0
	sprite.playing = true

func reload():
	pass

func _on_Timer_timeout():
	if initialize:
		initialize()
		initialize = false
	
	tween.interpolate_property(sprite,"scale",null,Vector2(1,1),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func save():
	var save_dict = {
		"animation": sprite.animation,
		"flip_h": sprite.flip_h,
		"res_path": res_path,
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
		elif k == "animation":
			sprite.animation = s[k]
			continue
		elif k == "flip_h":
			sprite.flip_h = s[k]
			continue
		
		set(k,s[k])
	
	reload()

func is_decoration():
	return true
