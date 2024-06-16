extends Area2D

onready var audio = $Audio
onready var tween = $Tween

onready var init_scale = scale

export var stream: AudioStream

func _ready():
	audio.stream = stream

func _on_Instrument_body_entered(body):
	if body is KinematicBody2D:
		audio.play()
		$Timer.start()
		Time.change_factor(str(stream),0.25)
		
		tween.remove_all()
		tween.interpolate_property(self,"scale",null,Vector2(init_scale.x,init_scale.y/2),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.interpolate_property($CollisionShape2D,"scale",null,Vector2(1,2),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()

func _on_Timer_timeout():
	Time.change_factor(str(stream),0)


func _on_Instrument_body_exited(body):
	if body is KinematicBody2D:
		tween.remove_all()
		tween.interpolate_property(self,"scale",null,init_scale,1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		tween.interpolate_property($CollisionShape2D,"scale",null,Vector2(1,1),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		tween.start()
