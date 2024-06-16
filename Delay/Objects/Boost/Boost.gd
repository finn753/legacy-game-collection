extends Area2D

onready var tween = $Tween
onready var sprite = $AnimatedSprite

func _on_Boost_body_entered(body):
	if body.has_method("set_boost"):
		body.set_boost(true)
		
		$AudioStreamPlayer.play()
		
		tween.remove_all()
		tween.interpolate_property(sprite,"scale",null,Vector2(1.5,1.5),1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		tween.start()

func _on_Boost_body_exited(body):
	if body.has_method("set_boost"):
		body.set_boost(false)
		
		tween.remove_all()
		tween.interpolate_property(sprite,"scale",null,Vector2(1.0,1.0),1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		tween.start()
