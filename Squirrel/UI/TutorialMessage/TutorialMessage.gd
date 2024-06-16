extends Label

onready var progress = $Progress
onready var audio = $AudioStreamPlayer

const msg_walking = "WASD or Arrow Keys to move"
const msg_climbing = "UP or Down to climb"
const msg_nuts = "Collect acorns to win"
const msg_age = "Every 10 seconds you'll age"

enum Tuts {NONE,WALKING,CLIMBING,NUTS,AGE}
var showing

func _ready():
	modulate = Color(1,1,1,0)
	Global.connect("time_changed",self,"on_time_changed")

func _process(delta):
	if Global.time == 1 && !Global.tutorial_walking_completed:
		text = msg_walking
		show(Tuts.WALKING)
	
	if Global.player != null:
		if Global.player.state == Global.player.STATES.Climb && !Global.tutorial_climbing_completed && showing == null:		
			text = msg_climbing
			show(Tuts.CLIMBING)
		elif !Global.tutorial_climbing_completed && showing == Tuts.CLIMBING && Global.player.state != Global.player.STATES.Climb:
			hide()
	
	if Global.tutorial_climbing_completed && Global.time >= 3 && Global.current_coins == 0 && showing == null:
		text = msg_nuts
		show(Tuts.NUTS)
	
	if showing == null && Global.tutorial_climbing_completed && !Global.tutorial_age_completed && Global.time >= 1:
		text = msg_age
		show(Tuts.AGE)
	
	if Global.current_coins >= 1:
		Global.tutorial_nuts_completed = true
	
	if Global.tutorial_nuts_completed && showing == Tuts.NUTS:
		hide()

func _unhandled_input(event):
	if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down") || Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"):
		Global.tutorial_walking_completed = true
		
		if showing == Tuts.WALKING:
			hide()
	
	if !Global.tutorial_climbing_completed && Global.player != null:
		if Global.player.state == Global.player.STATES.Climb && (Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down")):
			Global.tutorial_climbing_completed = true
			
			if showing == Tuts.CLIMBING:
				hide()

func on_time_changed():
	if showing == Tuts.AGE:
		Global.tutorial_age_completed = true
		hide()

func show(t = Tuts.NONE):
	var tween = create_tween()
	
	tween.tween_property(self,"modulate",Color(1,1,1,1),0.5)
	progress.rect_scale = Vector2(1,1)
	if showing != t && !audio.playing:
		audio.play()
		showing = t

func hide():
	var tween := create_tween()
	
	tween.tween_property(progress,"rect_scale",Vector2(0,1),2.0)
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.5)
	yield(tween,"finished")
	
	showing = null
