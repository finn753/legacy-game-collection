extends RigidBody2D

const TYPE = "Donut"

func get_TYPE():
	return TYPE

func _on_Area2D_body_entered(body):
	if body != null:
		print(body)
		
		if body.has_method("get_TYPE"):
			if body.TYPE != "Donut":
				queue_free()
		else:
			queue_free()
