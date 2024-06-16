extends ColorRect

onready var tween = $Tween

func _ready():
	Time.connect("time_over",self,"show_expl")
	
	modulate = Color(1,1,1,0)
	visible = true

func show_expl():
	tween.remove_all()
	tween.interpolate_property(self,"modulate",null,Color(1,1,1,1),1.0,Tween.TRANS_SINE,Tween.EASE_IN)
	tween.start()
