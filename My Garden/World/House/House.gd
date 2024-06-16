extends Node2D

onready var anim = $Ground/Door/AnimationPlayer

func _ready():
	Audio.play_sound("Door")
	var err = Global.connect("new_day",self,"new_day")
	if err == 0:
		err = 0

func new_day():
	anim.play("Sleep")
