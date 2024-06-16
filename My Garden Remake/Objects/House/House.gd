extends Area2D

onready var sprite = $AnimatedSprite
onready var canvas_mod = $CanvasModulate

onready var tween = $Tween

var inside = []
var is_inside = false

func _ready():
	sprite.visible = true

func inside_update():
	if !tween.is_inside_tree():
		return
	
	if inside.size() != 0:
		if is_inside:
			return
		is_inside = true
		tween.remove_all()
		tween.interpolate_property(sprite,"modulate",null,Color(1.0,1.0,1.0,0.0),0.15,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		tween.interpolate_property(canvas_mod,"color",null,Color(0.9,0.9,0.9,1.0),0.15,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		tween.start()
	else:
		if !is_inside:
			return
		is_inside = false
		tween.remove_all()
		tween.interpolate_property(sprite,"modulate",null,Color(1.0,1.0,1.0,1.0),0.15,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		tween.interpolate_property(canvas_mod,"color",null,Color(1.0,1.0,1.0,1.0),0.15,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		tween.start()

func _on_House_area_entered(a):
	if !inside.has(a):
		var b = a.get_parent().get_parent()
		if (b.has_method("is_movable_object") && b.is_walker) || a.get_parent().has_method("is_plant_mover"):
			inside.append(a)
		if b.get_parent().has_method("is_player"):
			b.get_parent().zoom = Vector2(0.25,0.25)
	
	inside_update()

func _on_House_area_exited(a):
	if inside.has(a):
		inside.erase(a)
	
	var b = a.get_parent().get_parent().get_parent()
	
	if b.has_method("is_player"):
		b.zoom = b.ZOOM
	
	inside_update()
