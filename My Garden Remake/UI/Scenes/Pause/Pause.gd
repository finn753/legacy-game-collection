extends Control

onready var dim = $Dim
onready var blur = $Blur
onready var tween = $Tween
onready var content = $Content

var paused = false
var queue_menu = false

func _ready():
	visible = false
	Global.connect("saved",self,"check_queue_menu")

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		toogle_pause()

func toogle_pause():
	if paused:
		hide()
	else:
		show()

func show():
	paused = true
	
	tween.remove_all()
	tween.interpolate_property(dim,"color",Color(0,0,0,0),Color(0,0,0,0.29),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(blur.material,"shader_param/blur_amount",0.0,2.0,0.5,Tween.TRANS_BACK,Tween.EASE_OUT)
	
	tween.interpolate_property(content,"margin_bottom",64.0,0.0,1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.interpolate_property(content,"margin_top",64.0,0.0,1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.interpolate_property(content,"modulate",Color(1,1,1,0),Color(1,1,1,1),0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(content,"rect_scale",Vector2(1.1,1.1),Vector2(1.0,1.0),1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	
	tween.start()
	
	visible = true
	get_tree().paused = true

func hide():
	paused = false
	
	tween.remove_all()
	tween.interpolate_property(dim,"color",null,Color(0,0,0,0),0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(blur.material,"shader_param/blur_amount",null,0.0,0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	
	tween.interpolate_property(content,"margin_bottom",null,64.0,0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(content,"margin_top",null,64.0,0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(content,"modulate",null,Color(1,1,1,0),0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.interpolate_property(content,"rect_scale",null,Vector2(1.1,1.1),0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	
	tween.start()
	
	get_tree().paused = false

func _on_Tween_tween_all_completed():
	visible = paused

func _on_Continue_button_down():
	hide()

func _on_Menu_button_down():
	hide()
	queue_menu = true
	Global.save_game()

func check_queue_menu():
	if queue_menu:
		get_tree().change_scene("res://UI/Scenes/Menu/Menu.tscn")
