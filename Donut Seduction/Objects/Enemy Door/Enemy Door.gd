extends StaticBody2D

onready var sprite = $AnimatedSprite
onready var area = $Area2D

func _on_Area2D_body_entered(body):
	if body.has_method("get_type") && body.get_type() == "Enemy":
			sprite.animation = "open"
			body.trap_influence = "Door"


func _on_Area2D_body_exited(body):
	if body.has_method("get_type") && body.get_type() == "Enemy":
			sprite.animation = "close"
			body.trap_influence = ""
