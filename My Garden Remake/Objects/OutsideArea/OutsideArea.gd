extends Area2D

onready var tween = $Tween

var bound_tl = Vector2(0,0)
var bound_br = Vector2(0,0)

var weed_res = preload("res://Objects/Decoration/Weed/Weed.tscn")
var stone_res = preload("res://Objects/Decoration/Stone/Stone.tscn")
var rock_res = preload("res://Objects/Decoration/Rock/Rock.tscn")
var mushroom_res = preload("res://Objects/Decoration/Mushroom/Mushroom.tscn")
var woodtile_res = preload("res://Objects/Decoration/WoodTile/WoodTile.tscn")

var plant_res = preload("res://Objects/Plant/Plant.tscn")

var fill_contents = [weed_res, weed_res, weed_res, plant_res, plant_res, rock_res, rock_res, stone_res, mushroom_res,woodtile_res]

func _ready():
	bound_tl = position
	bound_br = bound_tl + (scale * 16)
	
	Global.connect("clean_outside_area",self,"reload_area")

func reload_area():
	clean_area()
	$Timer.start() # fill_area()

func clean_area():
	print("clean")
	for a in get_overlapping_areas():
		var b = a.get_parent().get_parent()
		if b.has_method("is_movable_object") && b.deletable:
			b.animated_delete()

func fill_area():
	print("fill")
	randomize()
	
	var positions = []
	
	for i in range(20):
		var npos = Vector2()
		npos.x = float(randi()%int(bound_br.x - bound_tl.x)) + bound_tl.x
		npos.y = float(randi()%int(bound_br.y - bound_tl.y)) + bound_tl.y
		
		npos.x = floor(npos.x/16)*16
		npos.y = floor(npos.y/16)*16
		
		if npos in positions:
			i -= 1
			continue
		
		positions.append(npos)
	
	for i in positions:
		var nobj = fill_contents[randi()%fill_contents.size()].duplicate().instance()
		nobj.position = i
		
		if nobj.has_method("is_plant"):
			nobj.age = randi()%9
			nobj.color = Global.starter_flower_c
			nobj.species = Global.starter_flower_s
		elif nobj.has_method("is_decoration"):
			nobj.initialize = true
		
		get_parent().add_child(nobj)
	
	tween.start()

func _on_Timer_timeout():
	fill_area()
