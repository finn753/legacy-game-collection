extends Node2D

onready var player = $Objects/Player
onready var objects = $Objects
onready var bg = $ParallaxBackground/ColorRect

func _ready():
	Global.scene = "Factory Rescue"
	Sound.play_music("")
	if Motion.door != null:
		for p in objects.get_children():
			if p.has_method("get_type"):
				if p.get_type() == "Door":
					if p.id == Motion.door:
						Motion.door = null
						player.position = p.position
		Motion.door = null
	
	bg.visible = true
