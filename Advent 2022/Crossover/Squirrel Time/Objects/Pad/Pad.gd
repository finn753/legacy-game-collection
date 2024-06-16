extends StaticBody2D

export var break_age = 5

onready var tween = $Tween
onready var sprite = $Sprite

var stable = true

func _ready():
	Global.connect("time_changed",self,"on_time_changed")

func on_time_changed():
	if Global.time >= break_age:
		$CollisionShape2D.set_deferred("disabled",true)
		stable = false
	else:
		$CollisionShape2D.set_deferred("disabled",false)
		stable = true

func _on_Area2D_body_entered(body):
	if stable:
		tween.remove_all()
		tween.interpolate_property(sprite,"rotation_degrees",null,4,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
		tween.start()
	else:
		tween.remove_all()
		tween.interpolate_property(sprite,"rotation_degrees",null,60,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
		tween.start()

func _on_Area2D_body_exited(body):
	if body.has_method("is_player"):
		tween.remove_all()
		tween.interpolate_property(sprite,"rotation_degrees",null,0,0.5,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		tween.start()
