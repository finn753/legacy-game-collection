extends Area2D

onready var fire = $AnimatedSprite

export var coin = true
export var burning = true

func _process(delta):
	fire.visible = burning

func is_fire():
	return true

func _on_Fire_area_entered(area):
	if area.has_method("is_fire"):
		if area.burning:
			if !burning:
				burning = true
				if coin:
					Global.collect_coin()
