extends Area2D

export var scene = "World"

onready var sprite = $AnimatedSprite

func _ready():
	sprite.animation = "closed"

func _on_Door_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			sprite.animation = "open"
			
			if scene == "World":
				Global.join_world()
			if scene == "Menu":
				Global.join_menu()
			else:
				Global.join_room(scene)
