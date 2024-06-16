extends Area2D

onready var rprogress = $Progress
onready var destination = $Destination

onready var sprite = $AnimatedSprite

func _physics_process(delta):
	if Global.progress >= int(rprogress.text):
		if sprite.animation != "open":
			sprite.animation = "open"
	else:
		if sprite.animation != "default":
			sprite.animation = "default"
			
	for p in get_overlapping_bodies():
		if sprite.animation != "open":
			return
		
		if p.has_method("get_TYPE"):
			if p.TYPE == "Player":
				Global.load_room(destination.text)
