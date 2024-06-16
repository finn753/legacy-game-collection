extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content
onready var tween = $Tween

onready var sprite = content.get_node("AnimatedSprite")
onready var camera = content.get_node("Camera2D")
onready var sleeping_particle = content.get_node("SleepingParticle")

var step_sounds = [preload("res://Player/Step5.wav"),preload("res://Player/Step6.wav")]

const ZOOM = Vector2(0.3,0.3)
var zoom = ZOOM

var motion = Vector2(0,0)
var can_move = true
var locked_movement = false

var sqrt2 = sqrt(2.0)
var timeout_time = 0.2
var d_timeout_time = timeout_time * sqrt2

func _ready():
	grid.set_grid_pos(position)
	position = Vector2(0,0)
	Global.player_pos = grid.position
	timeout_time = $Timer.wait_time
	d_timeout_time = timeout_time * sqrt2

func _process(_delta):
	Global.player_pos = grid.position
	var cursor_grid_pos = grid.pixel2grid(Global.cursor_pos)
	
	var nczoom_mod = Global.player_pos.distance_to(cursor_grid_pos)/(16*13*16)
	var nczoom = zoom + Vector2(nczoom_mod,nczoom_mod)*zoom
	
	if Input.is_action_pressed("zoom_in"):
		nczoom /= 2
	
	if Input.is_action_pressed("zoom_out"):
		nczoom *= 2
	
	if Global.sleeping:
		nczoom = Vector2(0.4,0.4)
		$CameraTween.interpolate_property(camera,"zoom",null,nczoom,2.0,Tween.TRANS_BACK,Tween.EASE_OUT)
	else:
		$CameraTween.interpolate_property(camera,"position",null,(Global.cursor_pos - Global.player_pos) / 16,0.1,Tween.TRANS_SINE,Tween.EASE_OUT)
		$CameraTween.interpolate_property(camera,"zoom",null,nczoom,0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	
	$CameraTween.start()
	
	motion = Vector2(0,0)
	
	if Input.is_action_pressed("up"):
		motion.y -= 1
	
	if Input.is_action_pressed("down"):
		motion.y += 1
	
	if Input.is_action_pressed("left"):
		motion.x -= 1
	
	if Input.is_action_pressed("right"):
		motion.x += 1
	
	handle_motion(motion)

func handle_motion(m: Vector2, force = false):
	if !force:
		if m == Vector2() || !can_move || locked_movement:
			
			if !$AnimationPlayer.is_playing():
				$AnimationPlayer.play("Idle")
			
			return
	
	can_move = false
	
	var rr = randi()%step_sounds.size()
	print(rr)
	
	$AudioStreamPlayer.set_stream(step_sounds[rr])
	$AudioStreamPlayer.pitch_scale = 1 + ((randf()-0.5)/4)
	$AudioStreamPlayer.play()
	
	if motion.x != 0 && motion.y != 0:
		$Timer.wait_time = d_timeout_time
	else:
		$Timer.wait_time = timeout_time
	
	$Timer.start()
	
	var destination = grid.gridstep2pixel(m)
	var step = grid.gridstep2step(m)
	
	if m.x < 0:
		tween.interpolate_property(sprite,"scale",null,Vector2(-1,1),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
	elif m.x > 0:
		tween.interpolate_property(sprite,"scale",null,Vector2(1,1),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
	
	if !move.collide(step):
		grid.set_grid_pos(destination)
	$AnimationPlayer.play("Move")

func _on_Timer_timeout():
	can_move = true

func is_player():
	return true
