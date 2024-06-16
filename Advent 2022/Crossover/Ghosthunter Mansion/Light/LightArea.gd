extends Area2D

onready var n = str(get_instance_id()) + str(randi()%100)

var is_inside = false

func _ready():
	Global.connect("reset",self,"reset")

func reset():
	is_inside = false
	
	for b in get_overlapping_bodies():
		if b.has_method("is_player"):
			is_inside = true
			break
	
	if is_inside:
		Global.add_in_light(n)
	else:
		Global.remove_in_light(n)

func _on_LightArea_body_entered(body):
	if body.has_method("is_player"):
		is_inside = true
		Global.add_in_light(n)

func _on_LightArea_body_exited(body):
	if body.has_method("is_player"):
		is_inside = false
		Global.remove_in_light(n)
