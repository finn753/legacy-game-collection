extends Control

onready var dim = $Dim
onready var blur = $Blur
onready var tween = $Tween
onready var content = $Content

var paused = false
var queue_menu = false

func _ready():
	visible = false
	cheat_update()
	#Global.connect("saved",self,"check_queue_menu")

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
	tween.interpolate_property(dim,"modulate",Color(1,1,1,0),Color(1,1,1,1),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
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
	tween.interpolate_property(dim,"modulate",null,Color(1,1,1,0),0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
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
#	queue_menu = true
#	Global.save_game()
	get_tree().change_scene("res://UI/Scenes/Menu/Menu.tscn")

func check_queue_menu():
	if queue_menu:
		get_tree().change_scene("res://UI/Scenes/Menu/Menu.tscn")

func cheat_update():
	$"Content/Cheat Info".visible = Global.cheat_progress
	
	if Global.cheat_progress:
		$"Content/Cheats".text = "Cheats: On"
		$"Content/Cheat Info".visible = true
	else:
		$"Content/Cheats".text = "Cheats: Off"
		$"Content/Cheat Info".visible = false

func _on_Cheats_button_down():
	Global.cheat_progress = !Global.cheat_progress
	cheat_update()
