extends Label

onready var tween = $Tween

onready var init_pos = margin_top

func _ready():
	Time.connect("rate_changed",self,"show_anim")
	
	visible = true
	modulate = Color(1,1,1,0)

func show_anim():
	if Time.rate_change == "":
		return
	
	text = Time.rate_change
	
	tween.remove_all()
	tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),1.0,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(self,"margin_top",init_pos,init_pos - 16,1.0,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
