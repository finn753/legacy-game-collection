extends KinematicBody2D

onready var stween = $STween
onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer2D

onready var start_pos = position

export var reset_on_reset = false

export var walk_speed = 50
export var chase_speed = 250
var speed = walk_speed

export var slide = 5
export var stop_slide = 5.0
export var else_slide = 8
export var accel = 6

export var jump_height = 32.0
export var jump_time_to_peak = 0.4
export var jump_time_to_descent = 0.4

export var look_distance = 128
export var chase_look_distance = 256

export var no_wander = false
export var no_chase = false
export var check_height = false
export var make_sounds = false

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

const DEFAULT_GRAVITY = Vector2(0,1)

var movement_dir = 0
var velocity = Vector2()

var jump = false
var buffer_jump = false
var on_ground = false
var forced_jump = false

enum STATES {Idle, Walk, Jump, Fall, Climb, Glide}
var state = STATES.Idle
var last_state = state

enum AI_STATES {Wander, Chase}
var ai_state = AI_STATES.Wander
var last_ai_state = ai_state
var goal
var pause = 0

var is_visible = false

var sounds = [preload("res://Objects/NPC/Assets/Original/Fox1.wav"),preload("res://Objects/NPC/Assets/Original/Fox2.wav"),preload("res://Objects/NPC/Assets/Original/Fox3.wav")]

func _ready():
	audio.playing = false
	
	if reset_on_reset:
		Global.connect("reset",self,"reset")

func _process(delta):
	last_ai_state = ai_state
	ai_state = get_ai_state()
	#$Label.text = AI_STATES.keys()[ai_state]
#	var pc = Global.player
#	if pc != null:
#		$Label.text = str(round(rad2deg(Vector2(0,-1).angle_to(pc.position - position))))
	
	if pause > 0:
		pause -= delta
	
	set_behaviour()

func _physics_process(delta):
	last_state = state
	state = get_state()
	calculate_sprite()
	var snap = 1
	
	#Speed Smoothing
	var n_speed = speed * movement_dir
	
	if is_on_floor():
		if abs(n_speed) > abs(velocity.x) + 5:
			velocity.x = ((accel-1)*velocity.x + n_speed)/accel
		else:
			if abs(velocity.x) > stop_slide:
				velocity.x = ((slide-1)*velocity.x + n_speed)/slide
			else:
				velocity.x = 0
	else:
		if round(velocity.x) != round(n_speed):
			velocity.x = ((else_slide-1)*velocity.x + n_speed)/else_slide
	
	if is_on_floor():
		on_ground = true
	else:
		if $Coyote.is_stopped() && on_ground == true:
			$Coyote.start()
		
		if last_state == STATES.Climb && state != STATES.Climb && velocity.y < 0:
			jump = true
	
	if jump  || (buffer_jump && on_ground):
		jump = false
		buffer_jump = false
		on_ground = false
		snap = 0
		last_state = state
		state = STATES.Jump
		
		velocity.y = jump_velocity
	else:
		velocity.y += get_gravity() * delta
	
	var s = ceil(abs(scale.x))
	velocity.y = clamp(velocity.y,-384*s,384*s)
	
	#Move and Slide
	velocity = move_and_slide_with_snap(velocity,DEFAULT_GRAVITY*snap,-DEFAULT_GRAVITY,true,4,deg2rad(80))

func calculate_sprite():
	sprite.playing = true
	sprite.speed_scale = 1
	
	if movement_dir < 0:
		sprite.flip_h = true
	elif movement_dir > 0:
		sprite.flip_h = false
	
	if state == STATES.Idle:
		sprite.animation = "idle"
	elif state == STATES.Walk:
		sprite.animation = "walk"
		if movement_dir == 0:
			sprite.speed_scale = clamp((abs(velocity.x) / speed)*4,0,1)
	elif state == STATES.Jump:
		sprite.scale = (sprite.scale + Vector2(1.18,0.85))/2
		
#		if last_state != STATES.Jump:
#			print("Jump")
#			stween.remove_all()
#			stween.interpolate_property(sprite,"scale",null,Vector2(1.25,0.8),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
#			stween.start()
		sprite.animation = "jump"
	elif state == STATES.Fall:
		if !last_state == STATES.Climb && !is_on_ceiling():
			if last_state != STATES.Fall:
				stween.remove_all()
				stween.interpolate_property(sprite,"scale",null,Vector2(0.85,1.18),0.35,Tween.TRANS_SINE,Tween.EASE_OUT)
				stween.start()
			sprite.animation = "fall"
	elif state == STATES.Glide:
		sprite.animation = "walk"
	
	if state != STATES.Jump && state != STATES.Fall && sprite.scale != Vector2(1,1):
		if last_state == STATES.Jump || last_state == STATES.Fall:
			stween.remove_all()
		
		if !stween.is_active():
			stween.remove_all()
			stween.interpolate_property(sprite,"scale",null,Vector2(1,1),0.2,Tween.TRANS_BACK,Tween.EASE_OUT)
			stween.start()

func make_sound():
	if !make_sounds:
		return
	
	audio.pitch_scale = rand_range(1.5,2)
	audio.stream = sounds[randi()%sounds.size()]
	audio.play()

func get_state():
	var n_state = STATES.Idle
	
	if is_on_floor() && velocity.x != 0:
		n_state = STATES.Walk
	elif !is_on_floor() && velocity.y < 0 && state != STATES.Climb:
		n_state = STATES.Jump
	elif (!is_on_floor() && velocity.y > 0) || state == STATES.Climb:
		n_state = STATES.Fall
	
	return n_state

func get_ai_state():
	var p = Global.player
	
	if no_chase:
		return AI_STATES.Wander
	
	if !is_visible:
		return AI_STATES.Wander
	
	if p == null:
		return AI_STATES.Wander
	
#	if (!p.on_ground || p.state == p.STATES.Climb) && ai_state != AI_STATES.Chase:
#		return AI_STATES.Wander
	
	#var p_dist = position.distance_squared_to(p.position - Vector2(0,4))
	var p_dist = abs(p.position.x - position.x)
	#p_dist *= p_dist
	
	var ld = look_distance
	if ai_state == AI_STATES.Chase:
		ld = chase_look_distance
	
	if p_dist > ld:
		return AI_STATES.Wander
	
	if check_height:
		if abs(position.y - p.position.y) > 48:
			if ai_state != AI_STATES.Chase:
				return AI_STATES.Wander
			
			var angle = rad2deg(Vector2(0,-1).angle_to(p.position - position))
			
			if angle >= -27 && angle <= 27:
				return AI_STATES.Wander
		elif ai_state != AI_STATES.Chase:
			var angle = rad2deg(Vector2(0,-1).angle_to(p.position - position))
			
			if angle >= -35 && angle <= 35:
				return AI_STATES.Wander
	
	return AI_STATES.Chase

func set_behaviour():
	if ai_state == AI_STATES.Chase:
		var dist = position.x - Global.player.position.x
		
		goal = position.x + sign(position.x - Global.player.position.x)
		speed = chase_speed + (randi()%64 - 32)
		
		if !audio.playing && (randi()%100 == 0):
			print("Sound")
			make_sound()
	else:
		if !audio.playing && randi()%1000 == 0:
			make_sound()
		
		speed = walk_speed
		
		if goal != null && position.x >= goal-2 && position.x <= goal+2:
			goal = null
		
		if is_on_wall() && $Desinterest.is_stopped() && pause <= 0:
			$Desinterest.start()
		elif !is_on_wall():
			$Desinterest.stop()
		
		if goal == null && pause <= 0 && !no_wander:
			if randi()%2 == 0:
				pause = rand_range(0.25,1)
			else:
				goal = randi()%128-64 + position.x
		
		if pause > 0:
			goal = null
	
	if goal != null:
		movement_dir = sign(goal-position.x)
	else:
		movement_dir = 0
	
	if on_ground && is_on_wall() && ai_state == AI_STATES.Chase:
		jump = true

func get_gravity():
	if state == STATES.Jump:
		if !is_on_wall():
			return jump_gravity*1.5
		return jump_gravity
	return fall_gravity

func reset():
	velocity = Vector2()
	position = start_pos
	movement_dir = 0
	ai_state = AI_STATES.Wander

func death():
	reset()

func force_jump():
	jump = true
	
	if !forced_jump:
		forced_jump = true
		$ForceJump.start()
		return true
	return false

func _on_Coyote_timeout():
	on_ground = is_on_floor()

func _on_BufferJump_timeout():
	buffer_jump = false

func _on_ForceJump_timeout():
	forced_jump = false

func teleport(to: Vector2):
	set_position(to)

func is_npc():
	return true

func _on_Desinterest_timeout():
	goal = null

func _on_VisibilityNotifier2D_screen_entered():
	is_visible = true

func _on_VisibilityNotifier2D_screen_exited():
	is_visible = false
