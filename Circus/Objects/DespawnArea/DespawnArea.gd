extends Area2D

func _on_DespawnArea_body_entered(body):
	if body.has_method("despawn"):
		body.despawn()
