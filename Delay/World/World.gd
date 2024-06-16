extends Node2D

onready var audio = $AudioStreamPlayer
onready var tween = $Tween

func _ready():
	$ParallaxBackground/Sky.visible = true
	$ParallaxBackground/Sea.visible = true
	$ParallaxBackground/Sun.visible = true
	
	Time.connect("time_over",self,"time_over")
	Time.start()

#func _process(delta):
#	audio.pitch_scale = Time.time_rate

func time_over():
	tween.remove_all()
	tween.interpolate_property(audio,"volume_db",null,-80,1.0,Tween.TRANS_EXPO,Tween.EASE_IN)
	tween.start()

func _on_Tween_tween_all_completed():
	get_tree().change_scene("res://UI/Scene/Score/Score.tscn")
