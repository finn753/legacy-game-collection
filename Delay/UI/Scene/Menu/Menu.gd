extends CanvasLayer

onready var tween = $Tween
onready var body = $Body
onready var bg_anim = $BG/AnimationPlayer
onready var audio = $AudioStreamPlayer

onready var bonus = $Bonus

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

func _on_Play_pressed_safe():
	get_tree().change_scene("res://World/World.tscn")

func _on_Credits_pressed_safe():
	Global.pass_background_animation = $BG/AnimationPlayer.current_animation_position
	get_tree().change_scene("res://UI/Scene/Credits/Credits.tscn")

func _on_Help_pressed_safe():
	Global.pass_background_animation = $BG/AnimationPlayer.current_animation_position
	get_tree().change_scene("res://UI/Scene/Help/Help.tscn")

func _on_Play_button_down():
	if OS.has_feature("HTML5"):
		audio.stop()

func _on_BonusButton_button_down():
	bonus.show_bonus()
