extends Label

onready var tween = $Tween

func _ready():
	rect_pivot_offset = rect_size/2
	rect_scale = Vector2(0,0)
	visible = true
	
	Global.connect("saving",self,"play_save")
	Global.connect("saved",self,"play_end")

func play_save():
	print(Global.color_stats)
	print(Global.species_stats)
	
	text = "Saving..."
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(1,1),0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
	tween.start()

func play_end():
	text = "Saved"
	$Timer.start()

func _on_Timer_timeout():
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(0,0),0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
