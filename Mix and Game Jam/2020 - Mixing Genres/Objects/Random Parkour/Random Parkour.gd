extends Node2D

onready var color_rect = $ColorRect

var types = ["Spinning","Blocks"]
var type = 0

func _ready():
	color_rect.visible = false
	
	randomize()
	type = randi()%int(types.size())
	
	print(String(type))
	
	var o = load("res://Objects/Random Parkour/" + types[type] + ".tscn").instance()
	add_child(o)
