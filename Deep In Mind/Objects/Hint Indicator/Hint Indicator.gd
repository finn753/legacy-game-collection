extends Label

export var flash = 2

onready var animation = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name):
	flash -= 1
	
	if flash > 0:
		animation.play("Hint Flash")
