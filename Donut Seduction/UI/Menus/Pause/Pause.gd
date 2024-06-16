extends CanvasLayer

onready var animation = $AnimationPlayer

var visible = false

func pause():
	get_tree().paused = true
	visible = true
	animation.play("Show")

func unpause():
	visible = false
	animation.play("Hide")

func _on_Exit_button_down():
	if visible:
		unpause()
	elif !visible:
		pause()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hide":
		get_tree().paused = false


func _on_Title_button_down():
	get_tree().paused = false
	#unpause()
	Global.change_scene("res://UI/Title Screen/Menu.tscn")
