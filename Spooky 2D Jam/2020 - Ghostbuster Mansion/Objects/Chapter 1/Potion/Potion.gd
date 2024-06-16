extends Area2D

onready var sprite = $AnimatedSprite

func _on_Potion_body_entered(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player":
			if sprite.animation == "used":
				return
			body.speed = 450*body.SLOWDOWN
			sprite.animation = "used"
			Sound.play_point()
			Global.progress = 11
