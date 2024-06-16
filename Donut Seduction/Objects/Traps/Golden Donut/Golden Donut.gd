extends RigidBody2D

onready var sprite = $AnimatedSprite

const TYPE = "Golden Donut"

var eaten = false

func _ready():
	sprite.frame = 0

func get_type():
	return TYPE

func _on_Golden_Donut_body_entered(body):
	if eaten:
		return
	
	eaten = true
	
	if body.has_method("eat_gold"):
		body.eat_gold()
	else:
		Global.add_score(50)
	
	sprite.animation = "eat"


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "eat":
		queue_free()
