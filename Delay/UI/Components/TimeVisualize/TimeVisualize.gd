extends ColorRect

onready var tween = $Tween

export var rotate = false

func _ready():
	visible = true

func _process(delta):
	if rotate:
		rect_pivot_offset = Vector2(rect_size.x,rect_size.y/2)
	else:
		rect_pivot_offset = Vector2(rect_size.x/2,rect_size.y)
	
	tween.remove_all()
	if rotate:
		tween.interpolate_property(self,"rect_scale",null,Vector2(Time.time_rate,Time.percent_left),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	else:
		tween.interpolate_property(self,"rect_scale",null,Vector2(Time.percent_left,Time.time_rate),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
