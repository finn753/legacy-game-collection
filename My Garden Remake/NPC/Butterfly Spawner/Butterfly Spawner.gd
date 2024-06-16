extends Node2D

onready var butterfly_res = preload("res://NPC/Butterfly/Butterfly.tscn")

export var flowers_per_butterfly = 10.0
export var flower_buffer = 20

var spawn_points = []

func _ready():
	Global.connect("new_day",self,"start_spawn")
	
	for c in get_children():
		if c == $SpawnTimer:
			continue
		spawn_points.push_back(c.position)
	
	start_spawn()

func start_spawn():
	$SpawnTimer.start()

func spawn():
	print(Global.color_stats)
	for k in Global.color_stats.keys():
		var c = Global.color_stats[k]
		var num = ceil((c - flower_buffer)/flowers_per_butterfly)
		if num <= 0:
			continue
		for i in range(num):
			var new_butterfly = butterfly_res.instance().duplicate()
			new_butterfly.position = spawn_points[randi()%spawn_points.size()]
			new_butterfly.color = k
			get_parent().call_deferred("add_child",new_butterfly)

func sum_dictionary(dic):
	var sum = 0
	for n in dic.keys():
		sum += dic[n]
	return sum

func _on_SpawnTimer_timeout():
	spawn()
