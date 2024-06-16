extends AnimatedSprite

onready var anim = $AnimationPlayer

func _process(_delta):
	if Global.current_trap != "":
		if !visible:
			anim.play("Spawn")
		
		var mouse_position = get_global_mouse_position()
		
		if Global.invert_placement:
			mouse_position =  Global.player_pos - (mouse_position - Global.player_pos)
		
		if Vector2(round(position.x),round(position.y)) != get_global_mouse_position():
			position = (position + mouse_position)/2
		else:
			position = mouse_position
	else:
		if visible && !anim.is_playing():
			anim.play("Place")
		elif !visible:
			position = Vector2(get_global_mouse_position().x,900)


func _on_PlaceButton_pressed():
	Input.action_press("place")

func _on_PlaceButton_released():
	Input.action_release("place")
