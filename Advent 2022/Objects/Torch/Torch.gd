extends Area2D

onready var fire = $Fire

var pickable = true
var holder

var burning = true
var air_time = 0

func _process(delta):
	fire.visible = burning
	
	if holder != null:
		if !holder.is_on_floor():
			air_time += delta
		else:
			air_time = 0
	else:
		air_time = 0
	
	fire.scale = Vector2(1-air_time,1-air_time)
	
	if air_time > 0.67:
		burning = false
		air_time = 0

func _on_Pickable_body_entered(body):
	if body.has_method("is_player"):
		if body.holding == null && pickable:
			body.holding = self
			holder = body
			pickable = false

func is_fire():
	return true

func _on_Torch_area_entered(area):
	if area.has_method("is_fire"):
		if area.burning:
			burning = true
