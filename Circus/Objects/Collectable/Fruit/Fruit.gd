extends AnimatedSprite

func _ready():
	if Global.has_item(animation):
		queue_free()

func _on_Area2D_body_entered(body):
	if body.has_method("is_player"):
		collect()

func collect():
	Global.add_item(animation)
	print(Global.inventory)
	queue_free()
