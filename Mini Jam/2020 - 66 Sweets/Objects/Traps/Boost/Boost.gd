extends Area2D

const M = 8
var b = null

func _on_Boost_body_entered(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player" || body.TYPE == "Enemy":
			body.movement *= M
			
func _physics_process(delta):
	for body in get_overlapping_bodies():
		_on_Boost_body_entered(body)

func _on_Boost_body_exited(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player" || body.TYPE == "Enemy":
			queue_free()
