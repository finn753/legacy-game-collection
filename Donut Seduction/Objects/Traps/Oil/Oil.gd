extends Area2D

onready var timer = $Timer
onready var sprite = $AnimatedSprite

var trap_influence = "Oil"
var block_influence = false

func _ready():
	sprite.frame = 0

func disapear():
	block_influence = true
	for body in get_overlapping_bodies():
		if body.has_method("set_trap_influence"):
			if body.trap_influence == trap_influence:
				body.trap_influence = ""
	queue_free()

func _on_Slime_body_entered(body):
	if !block_influence:
		if body.has_method("set_trap_influence"):
			body.set_trap_influence(trap_influence)
			if Tool.is_in_area_vector(get_global_transform_with_canvas().origin,Vector2(),Global.screen_size):
				Audio.play_sound("Boost",true)

func _on_Slime_body_exited(body):
	if body.has_method("set_trap_influence"):
		if body.trap_influence == trap_influence:
			body.trap_influence = ""
			if Tool.is_in_area_vector(get_global_transform_with_canvas().origin,Vector2(),Global.screen_size):
				Audio.play_sound("Boost",true)


func _on_Timer_timeout():
	disapear()
