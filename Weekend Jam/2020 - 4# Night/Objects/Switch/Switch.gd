extends Area2D

onready var sprite = $AnimatedSprite

export var pressed = false

func _ready():
	pressed = false

func _process(delta):
	if pressed:
		sprite.animation = "on"
	else:
		sprite.animation = "off"


func _on_Switch_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			Sound.play_sound("Press")
			pressed = true

func _on_Switch_body_exited(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			pressed = false
