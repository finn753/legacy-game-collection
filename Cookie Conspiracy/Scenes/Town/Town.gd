extends Node2D

onready var objects = $Objects
onready var player = $Objects/Player

func _ready():
	Global.scene = "Town"
	Sound.play_music("Town")
	if Motion.door != null:
		for p in objects.get_children():
			if p.has_method("get_type"):
				if p.get_type() == "Door":
					if p.id == Motion.door:
						Motion.door = null
						player.position = p.position
