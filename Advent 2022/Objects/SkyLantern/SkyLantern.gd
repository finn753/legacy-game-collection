extends KinematicBody2D

onready var start_pos = position
export var speed = 25

var fly = false

func _ready():
	Global.connect("reset",self,"reset")

func _physics_process(delta):
	if fly:
		position.y -= speed*delta
	else:
		if position.y < start_pos.y - speed:
			position.y += speed*delta
		elif round(position.y) != round(start_pos.y):
			position.y = (((speed*2)-1)*position.y + start_pos.y)/(speed*2)

func reset():
	position = start_pos

func _on_Area2D_body_entered(body):
	if body.has_method("is_player"):
		fly = true

func _on_Area2D_body_exited(body):
	if body.has_method("is_player"):
		fly = false
