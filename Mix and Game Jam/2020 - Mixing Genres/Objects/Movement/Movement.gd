extends Area2D

export var x_scale = 0.0
export var y_scale = 0.0

func _physics_process(delta):
	for p in get_overlapping_bodies():
		if p.has_method("_integrate_forces"):
			p.force_queue = Vector2(p.linear_velocity.x*x_scale,p.linear_velocity.y*y_scale)
