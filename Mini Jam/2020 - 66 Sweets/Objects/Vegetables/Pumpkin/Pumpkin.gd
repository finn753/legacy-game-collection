extends Area2D

onready var sprite = $AnimatedSprite

var destroyed = false

func _ready():
	destroyed = false
	sprite.animation = "default"

func _on_Pumpkin_body_entered(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player":
			if !destroyed:
				destroyed = true
				sprite.animation = "destroyed"
				
				Sound.play_sound("point")
				Global.score += 10*scale.x
