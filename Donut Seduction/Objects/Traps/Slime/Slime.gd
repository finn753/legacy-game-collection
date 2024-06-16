extends Area2D

onready var timer = $Timer
onready var sprite = $AnimatedSprite

var trap_influence = "Slime"
var block_influence = false

func _ready():
	sprite.frame = 0

func disapear():
	block_influence = true
	for body in get_overlapping_bodies():
		if body.has_method("set_trap_influence"):
			if body.trap_influence == trap_influence:
				body.trap_influence = ""
	sprite.animation = "free"

func _on_Slime_body_entered(body):
	if !block_influence:
		if body.has_method("set_trap_influence"):
			body.set_trap_influence(trap_influence)
			timer.start()
			if body.get_type() == "Enemy":
				#Audio.play_sound("Stick")
				Global.add_score(100)

func _on_Slime_body_exited(body):
	if body.has_method("set_trap_influence"):
		if body.trap_influence == trap_influence:
			body.trap_influence = ""


func _on_Timer_timeout():
	disapear()


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "free":
		queue_free()
