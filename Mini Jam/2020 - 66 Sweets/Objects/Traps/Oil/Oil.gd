extends Area2D

var N = 135
var R = deg2rad(N)

func _on_Oil_body_entered(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player" || body.TYPE == "Enemy":
			body.movement = body.movement.rotated(R)
			N -= 1
			if N <= 0:
				queue_free()
			R = deg2rad(N)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		_on_Oil_body_entered(body)

func _on_Oil_body_exited(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player" || body.TYPE == "Enemy":
			pass
			#queue_free()
