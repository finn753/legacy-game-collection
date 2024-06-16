extends ScrollContainer

onready var container = $Container

var select_button_res = preload("res://UI/GUI/GameSelectButton/GameSelectButton.tscn")

var toggle = false
var update_children = false
var percent_visible = 1.0
var last_num = -1

func _ready():
	get_v_scrollbar().set_scale(Vector2(0,0))
	modulate = Color(1,1,1,0)
	container.rect_position = Vector2(0,64)
	reload_content()

func _process(delta):
	if update_children:
		update_visible_children()

func reload_content():
	for c in container.get_children():
		c.queue_free()
	
	for g in Global.get_saved_games():
		var new_button = select_button_res.duplicate(true).instance()
		container.add_child(new_button)
		print(g)
		new_button.get_node("Text").text = g

func update_visible_children():
	var cchildren = container.get_children()
	
	var num = int(cchildren.size() * percent_visible)
	if last_num == num:
		return
	
	last_num = num
	
	for c in cchildren:
		if num >= 1:
			c.visible = true
			num -= 1
		else:
			c.visible = false

func show():
	visible = false
	toggle = true
	reload_content()
	update_visible_children()
	visible = true
	
	$Tween.remove_all()
	#$Tween.interpolate_property(self,"percent_visible",null,1.0,0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"modulate",null,Color(1,1,1,1),0.125,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(container,"rect_position",Vector2(0,container.rect_size.y),Vector2(0,0),0.125,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
	#update_children = true

func hide():
	toggle = false
	
	$Tween.remove_all()
	#$Tween.interpolate_property(self,"percent_visible",null,0.0,0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"modulate",null,Color(1,1,1,0),0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.interpolate_property(container,"rect_position",null,Vector2(0,container.rect_size.y),0.25,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
	#update_children = true

func toggle_visibility():
	if toggle:
		hide()
	else:
		show()

func _on_Tween_tween_all_completed():
	update_children = false
	if toggle:
		percent_visible = 1.0
	else:
		percent_visible = 0.0
		visible = false
	update_visible_children()
