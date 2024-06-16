extends Label

onready var tween = $Tween

func _ready():
	visible = true
	rect_pivot_offset = rect_size / 2
	rect_scale = Vector2(0,0)

func _process(_delta):
	if !tween.is_active() && text == "":
		visible = false
	else:
		visible = true
	
	if text != Global.text_box:
		tween.remove_all()
		if Global.text_box == "":
			tween.interpolate_property(self,"rect_scale",null,Vector2(0,0),0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
			#$Tween.interpolate_property(self,"percent_visible",null,0,0.6,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
			$Off.play(0)
		else:
			tween.interpolate_property(self,"rect_scale",null,Vector2(1,1),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
			#$Tween.interpolate_property(self,"percent_visible",null,1,0.6,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
			$On.play(0)
		text = Global.text_box
		tween.start()
