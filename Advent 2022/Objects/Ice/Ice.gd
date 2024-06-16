extends Area2D

export var ice_slide = 32
export var ice_stop = 1.0

export var slide = 5
export var stop = 5.0

func _on_Ice_body_entered(body):
	if body.has_method("is_player"):
		body.slide = ice_slide
		body.stop_slide = ice_stop

func _on_Ice_body_exited(body):
	if body.has_method("is_player"):
		body.slide = slide
		body.stop_slide = stop
