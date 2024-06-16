extends Label

onready var anim = $AnimationPlayer

func _ready():
	var err = Global.connect("new_message",self,"new_message")
	if err == 0:
		err = 0

func new_message(m):
	if m != "":
		text = m
		anim.play("PopIn")
	else:
		anim.play("PopOut")
