extends Button

onready var animation = $AnimationPlayer

func _on_Button_mouse_entered():
	Audio.play_sound("Hover")
	animation.play("Hover")

func _on_Button_mouse_exited():
	Audio.play_sound("UnHover")
	animation.play("UnHover")

func _on_Button_button_down():
	Audio.play_sound("Click")
