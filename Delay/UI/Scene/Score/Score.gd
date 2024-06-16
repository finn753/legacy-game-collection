extends CanvasLayer

onready var tween = $Tween
onready var body = $Body

func _ready():
	$Body/Time.text = str(Time.actual_time_passed)
	$Body/Line/Line2D.points = PoolVector2Array(Time.rate_history)
	
	if Time.actual_time_passed > Save.highscore:
		Save.highscore = Time.actual_time_passed
		Save.highscore_points = Time.rate_history
		$Body/Highscore.text = "New Highscore"
	else:
		$Body/Highscore.text = "Hi " + str(Save.highscore)
	
	Save.save_settings()
	
	body.rect_pivot_offset = body.rect_size/2
	body.rect_scale = Vector2(2,2)
	
	tween.remove_all()
	tween.interpolate_property(body,"rect_scale",Vector2(2,2),Vector2(1,1),2,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func _on_Again_pressed_safe():
	get_tree().change_scene("res://World/World.tscn")

func _on_Home_pressed_safe():
	get_tree().change_scene("res://UI/Scene/Menu/Menu.tscn")
