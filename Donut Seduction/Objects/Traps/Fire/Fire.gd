extends Area2D

onready var sprite = $AnimatedSprite

var trap_influence = "Fire"
var block_influence = false

func _ready():
	sprite.frame = 0

func disapear():
	sprite.animation = "free"

func _on_Slime_body_entered(body):
	if !block_influence:
		if body.has_method("hit") && body.get_type() == "Enemy":
			body.hit()
			disapear()


func _on_PlayerCol_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		disapear()


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "free":
		queue_free()
	else:
		sprite.animation = "default"
