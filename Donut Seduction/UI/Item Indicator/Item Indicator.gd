extends AnimatedSprite

onready var anim = $AnimationPlayer

func _process(_delta):
	if animation != Global.current_trap:
		if Global.current_trap == "":
			Audio.play_sound("Place")
		
		animation = Global.current_trap
		anim.play("NewItem")
