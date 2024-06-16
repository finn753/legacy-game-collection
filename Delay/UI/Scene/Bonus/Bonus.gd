extends Control

onready var tween = $Tween
onready var body = $Body
onready var bg_anim = $BG/AnimationPlayer

func _ready():
	anchor_left = 1
	anchor_right = 2
	visible = true

func show_bonus():
	Eco.validate_installed_games()
	
	tween.remove_all()
	tween.interpolate_property(self,"anchor_left",null,0,1.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.interpolate_property(self,"anchor_right",null,1,1.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()

func hide_bonus():
	tween.remove_all()
	tween.interpolate_property(self,"anchor_left",null,1,0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(self,"anchor_right",null,2,0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()


func _on_Back_button_down():
	hide_bonus()
