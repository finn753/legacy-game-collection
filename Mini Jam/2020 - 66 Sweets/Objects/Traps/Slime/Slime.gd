extends Area2D

onready var timer = $Timer

func _on_Slime_body_entered(body):
	timer.start()

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("get_TYPE"):
			if body.TYPE == "Player" || body.TYPE == "Enemy":
				body.movement = Vector2(0,0)

func _on_Slime_body_exited(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player" || body.TYPE == "Enemy":
			queue_free()

func _on_Timer_timeout():
	queue_free()
