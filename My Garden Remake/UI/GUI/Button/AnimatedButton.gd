extends Button

onready var tween = $Tween

var free_leave = false

func _ready():
	rect_pivot_offset = rect_size/2

func _on_AnimatedButton_mouse_entered():
	$Select.play()
	rect_pivot_offset = rect_size/2
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(1.25,1.25),1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func _on_AnimatedButton_mouse_exited():
	if free_leave:
		free_leave = false
		return
	
	$Deselect.play()
	rect_pivot_offset = rect_size/2
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(1,1),1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func _on_AnimatedButton_button_down():
	free_leave = true
	$Click.play()
	rect_pivot_offset = rect_size/2
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(1.0,1.0),0.25,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	tween.start()
