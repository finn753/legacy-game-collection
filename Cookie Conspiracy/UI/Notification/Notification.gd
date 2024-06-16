extends HBoxContainer

export(String,MULTILINE) var text = ""

onready var label = $Label

func _ready():
	label.text = text
	Sound.play_sound("Notification")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
