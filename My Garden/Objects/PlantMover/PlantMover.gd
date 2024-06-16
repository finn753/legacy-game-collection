extends Area2D

onready var sprite = $AnimatedSprite
onready var animation = $AnimationPlayer

var carrying = null

func _process(_delta):
	position = get_global_mouse_position()
	
	if carrying != null:
		carrying.position = position
		sprite.animation = "grabbing"
	else:
		sprite.animation = "default"

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action"):
		grabbing()


func grabbing():
	if carrying == null:
		for a in get_overlapping_areas():
			if a.get_parent().has_method("grab"):
				Audio.play_sound("Pickup")
				carrying = a.get_parent()
				carrying.grab()
				break
	else:
		Audio.play_sound("Place")
		carrying.ungrab()
		carrying = null

func _on_PlantMover_area_entered(a):
	if carrying == null:
		if a.get_parent().has_method("grab"):
			Audio.play_sound("Hover")
			animation.play("CanGrab")


func _on_Button_button_down():
	grabbing()
