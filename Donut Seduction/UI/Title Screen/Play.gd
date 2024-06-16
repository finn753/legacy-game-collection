extends Button

onready var animation = $AnimationPlayer

func _on_Play_mouse_entered():
	animation.play("Hover")

func _on_Play_mouse_exited():
	animation.play("UnHover")
