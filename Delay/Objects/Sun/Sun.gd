extends TextureRect

onready var tween = $Tween

func _ready():
	Time.connect("time_over",self,"end")

func _process(delta):
	if !Time.running:
		return
	
	var s = 1 + (1 - Time.percent_left)*3
	
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(s,s),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()

func end():
	print("End")
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(16,16),0.5,Tween.TRANS_EXPO,Tween.EASE_IN)
	tween.start()
	
