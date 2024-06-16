extends CanvasLayer

onready var tween = $Tween
onready var body = $Body
onready var bg_anim = $BG/AnimationPlayer

func _ready():
	body.rect_pivot_offset = body.rect_size/2
	body.rect_scale = Vector2(2,2)
	
#	if Global.pass_background_animation != null:
#		bg_anim.seek(Global.pass_background_animation)
#		Global.pass_background_animation = null
	
	$Body/Version.text = Global.VERSION
	
	tween.remove_all()
	tween.interpolate_property(body,"rect_scale",Vector2(2,2),Vector2(1,1),2,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func _process(delta):
	$BG/AnimationRect.rect_pivot_offset = $BG/AnimationRect.rect_size/2

func _on_Back_pressed_safe():
	Global.pass_background_animation = $BG/AnimationPlayer.current_animation_position
	get_tree().change_scene("res://UI/Scene/Menu/Menu.tscn")
