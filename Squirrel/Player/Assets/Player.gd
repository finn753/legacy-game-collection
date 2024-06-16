extends KinematicBody2D

onready var rot_tween = $RotTween
onready var stween = $STween
onready var sprite = $Sprite
onready var audio_j = $Jump
onready var audio_l = $Land
onready var camera = $Camera2D

onready var lim_bot = camera.limit_bottom
onready var lim_top = camera.limit_top
onready var c_lim_bot: float = lim_bot
onready var c_lim_top: float = lim_top

export var ignore_age = false
export var speed = 300

export var jump_height = 64.0
export var jump_time_to_peak = 0.4
export var jump_time_to_descent = 0.4

export var can_climb = true
export var climb_speed = 200

export var can_move = true

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

const DEFAULT_GRAVITY = Vector2(0,1)

var movement_dir = 0
var climb_dir = 0
var inv_mov = 1
var velocity = Vector2()
var climb_origin

var jump = false
var buffer_jump = false
var on_ground = false
var forced_jump = false

enum STATES {Idle, Walk, Jump, Fall, Climb, Glide}
var state = STATES.Idle
var last_state = state

var anim_pref = ""

func _ready():
	Global.player = self
	Global.connect("time_changed",self,"on_time_changed")
	update_stats()

func _process(delta):
	get_input()
	update_camera(delta)
	$Label.text = STATES.keys()[state]# + " -- " + str(rotation_degrees)

func _physics_process(delta):
	last_state = state
	state = get_state()
	calculate_sprite()
	var snap = 1
	climb_dir = 0
	
	#Speed Smoothing
	var n_speed = speed * movement_dir
	
	if is_on_floor() || !can_climb:
		if get_collision_mask_bit(2) != false:
			set_collision_mask_bit(2,false)
	elif !is_on_floor() && can_climb:
		if get_collision_mask_bit(2) != true:
			set_collision_mask_bit(2,true)
	
	if is_on_floor():
		climb_origin = null
		if abs(n_speed) > abs(velocity.x):
			velocity.x = (15*velocity.x + n_speed)/16
		else:
			if abs(velocity.x) > 5:
				velocity.x = (3*velocity.x + n_speed)/4
			else:
				velocity.x = 0
	else:
		if abs(n_speed) < abs(velocity.x):
			velocity.x = (15*velocity.x + n_speed)/16
		else:
			velocity.x = (7*velocity.x + n_speed)/8
	
#	var wall
		
#	for i in range(get_slide_count()):
#		var col = get_slide_collision(i)
#		var b = col.collider
#
#		#col.position.y >= position.y &&
#		if b.has_method("trigger_break"):
#			b.trigger_break()
#
#		var vec = col.position - position 
#		var y_dist = abs(vec.y)
#
#		if y_dist > 5:
#			continue
#
#		if b.has_method("get_vel"):
#			wall = b
	
	if is_on_floor() || (state == STATES.Climb):
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
		audio_j.play()
		
		velocity.y = jump_velocity
	elif state == STATES.Climb:
		climb_dir = Input.get_vector("null","null","up","down").y
		
		var stick_vec = Vector2(0,0)
		
#		if wall != null:
#			if climb_origin == null || last_state != STATES.Climb:
#				climb_origin = wall.position
#
#			stick_vec = wall.position - climb_origin
#			climb_origin = wall.position
		
		position += stick_vec
		
		var nc_speed = climb_speed * climb_dir
		velocity.y = nc_speed
		velocity.x = round(velocity.x/10)*10
		
		if sprite.flip_h:
			velocity.x -= 4
		else:
			velocity.x += 4
		
		if climb_dir == 0:
			if velocity.y >= 0:
				velocity.y = 0
			else:
				velocity.y += get_gravity() * delta
	else:
		velocity.y += get_gravity() * delta
	
	var s = ceil(abs(scale.x))
	velocity.y = clamp(velocity.y,-384*s,384*s)
	
	#Move and Slide
	velocity = move_and_slide_with_snap(velocity,DEFAULT_GRAVITY*snap,-DEFAULT_GRAVITY,true,4,deg2rad(80))

func get_input(): 
	if !can_move:
		movement_dir = 0
		jump = false
		buffer_jump = false
		return
	
	movement_dir = Input.get_vector("left","right","null","null").x
	
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right") :
		# -90 bis 90 normal
		if rotation_degrees > 92 || (rotation_degrees < -92 && rotation_degrees > -200):
			inv_mov = -1
		else:
			inv_mov = 1
	
	movement_dir *= inv_mov
	
	var try_jump = false
	
	if Input.is_action_just_pressed("jump") || (Input.is_action_just_pressed("up") && on_ground && is_on_wall()):
		try_jump = true
	
	if forced_jump:
		try_jump = false
	
	if try_jump && state != STATES.Climb:
		if on_ground:
			jump = true
		else:
			buffer_jump = true
			$BufferJump.start()

func calculate_sprite():
	sprite.playing = true
	sprite.speed_scale = 1
	
	if movement_dir < 0:
		sprite.flip_h = true
	elif movement_dir > 0:
		sprite.flip_h = false
	
	if state != STATES.Climb:
		sprite.flip_v = false
	
	if last_state == STATES.Climb && state != STATES.Climb && is_on_floor():
		print(state)
		print("flip")
		sprite.flip_h = !sprite.flip_h
	
	if state == STATES.Idle:
		sprite.animation = anim_pref + "idle"
	elif state == STATES.Walk:
		sprite.animation = anim_pref + "walk"
		if movement_dir == 0:
			sprite.speed_scale = clamp((abs(velocity.x) / speed)*4,0,1)
	elif state == STATES.Climb:
		sprite.animation = anim_pref + "climb"
		if climb_dir == 0:
			sprite.playing = false
		elif climb_dir == 1:
			sprite.flip_v = true
		else:
			sprite.flip_v = false
	elif state == STATES.Jump:
		sprite.scale = (sprite.scale + Vector2(1.18,0.85))/2
		
#		if last_state != STATES.Jump:
#			print("Jump")
#			stween.remove_all()
#			stween.interpolate_property(sprite,"scale",null,Vector2(1.25,0.8),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
#			stween.start()
		sprite.animation = anim_pref + "jump"
	elif state == STATES.Fall:
		if !last_state == STATES.Climb && !is_on_ceiling():
			if last_state != STATES.Fall:
				stween.remove_all()
				stween.interpolate_property(sprite,"scale",null,Vector2(0.85,1.18),0.35,Tween.TRANS_SINE,Tween.EASE_OUT)
				stween.start()
			sprite.animation = anim_pref + "fall"
	
	if state != STATES.Jump && state != STATES.Fall && sprite.scale != Vector2(1,1):
		if last_state == STATES.Jump || last_state == STATES.Fall:
			stween.remove_all()
		
		if !stween.is_active():
			stween.remove_all()
			stween.interpolate_property(sprite,"scale",null,Vector2(1,1),0.2,Tween.TRANS_BACK,Tween.EASE_OUT)
			stween.start()
			$Land.play()
	
	if Global.time == 10:
		$Sprite.animation = "dead"

func update_camera(delta):
#	n_cam_lim_bot = cam_lim_bot
#	camera.limit_bottom = n_cam_lim_bot
	
	
	if position.x >= -2176 && position.x < -1024:
		#Trees
		smooth_cam_bot(lim_bot)
		smooth_cam_top(lim_top)
		smooth_cam_zoom(Vector2(0.5,0.5))
	elif position.x >= -1024 && position.x <-8320:
		#Hill2L
		smooth_cam_bot(224)
		smooth_cam_top(lim_top)
		smooth_cam_zoom(Vector2(0.45,0.45))
	elif position.x >= -832 && position.x < 0:
		#Pads
		smooth_cam_top(160)
		smooth_cam_bot(464)
		#smooth_cam_top(lim_top)
		#smooth_cam_bot(448)
		smooth_cam_zoom(Vector2(0.45,0.45))
	elif position.x >= 0 && position.x < 192:
		#HillL
		smooth_cam_top(lim_top)
		smooth_cam_bot(416)
	elif position.x >= 192 && position.x < 864:
		#Home
		smooth_cam_top(lim_top)
		smooth_cam_bot(416)
	elif position.x >= 864 && position.x < 960:
		#HillR
		smooth_cam_top(lim_top)
		smooth_cam_bot(384)
	elif position.x >= 960 && position.x <= 2016:
		#Forest
		smooth_cam_top(lim_top)
		smooth_cam_bot(352)
	else:
		#Rest
		smooth_cam_bot(lim_bot)
		smooth_cam_top(lim_top)
		smooth_cam_zoom(Vector2(0.4,0.4))

func smooth_cam_bot(v):
	v = float(v)
	
	if v > camera.limit_bottom:
		c_lim_bot = v
	else:
		var tween = create_tween()
		tween.tween_property(self,"c_lim_bot",v,1.0)
		#c_lim_bot = (199*c_lim_bot + v)/200
	
	camera.limit_bottom = c_lim_bot

func smooth_cam_top(v):
	v = float(v)
	
	if v < camera.limit_top:
		c_lim_top = v
	else:
		var tween = create_tween()
		tween.tween_property(self,"c_lim_top",v,1.0)
		#c_lim_top = (199*c_lim_top + v)/200
	
	camera.limit_top = c_lim_top

func smooth_cam_zoom(v):
	var tween = create_tween()
	tween.tween_property(camera,"zoom",v,1.0)
	#camera.zoom = (999*camera.zoom + v)/1000

func get_state():
	var n_state = STATES.Idle
	
	if is_on_floor() && velocity.x != 0:
		n_state = STATES.Walk
	elif !is_on_floor() && velocity.y < 0 && state != STATES.Climb:
		n_state = STATES.Jump
	elif (!is_on_floor() && velocity.y > 0) || state == STATES.Climb:
		n_state = STATES.Fall
	
	if n_state == STATES.Fall:
		if is_on_wall() && state != STATES.Glide && can_climb:
			n_state = STATES.Climb
	
	return n_state

func get_gravity():
	if state == STATES.Jump:
		if !Input.is_action_pressed("jump"):
			return jump_gravity*1.5
		return jump_gravity
	return fall_gravity

func update_stats():
	if ignore_age:
		return
	
	if Global.time == 0:
		speed = 100
		
		jump_height = 16.0
		jump_time_to_peak = 0.25
		jump_time_to_descent = 0.25
		
		can_climb = false
		
		scale = Vector2(0.75,0.75)
		
		anim_pref = "0"
	elif Global.time == 1:
		speed = 150
		climb_speed = 75
		
		jump_height = 24.0
		jump_time_to_peak = 0.3
		jump_time_to_descent = 0.3
		
		can_climb = true
		
		scale = Vector2(0.8,0.8)
		
		anim_pref = "G"
	elif Global.time == 2:
		speed = 200
		climb_speed = 125
		
		jump_height = 32.0
		jump_time_to_peak = 0.35
		jump_time_to_descent = 0.35
		
		scale = Vector2(0.85,0.85)
	elif Global.time == 3:
		speed = 250
		climb_speed = 150
		
		jump_height = 48.0
		jump_time_to_peak = 0.4
		jump_time_to_descent = 0.4
		
		scale = Vector2(0.9,0.9)
	elif Global.time == 4:
		speed = 275
		climb_speed = 175
		
		jump_height = 64.0
		jump_time_to_peak = 0.45
		jump_time_to_descent = 0.45
		
		scale = Vector2(0.95,0.95)
		
		# Debug
		can_climb = true
		anim_pref = "G"
	elif Global.time == 5:
		speed = 300
		climb_speed = 200
		
		jump_height = 64.0
		jump_time_to_peak = 0.4
		jump_time_to_descent = 0.4
		
		scale = Vector2(1,1)
		
		anim_pref = ""
		
		#Debug
		can_climb = true
	elif Global.time == 6:
		jump_time_to_peak = 0.4
		jump_time_to_descent = 0.35
		
		anim_pref = ""
	elif Global.time == 7:
		speed = 250
		climb_speed = 150
		
		jump_height = 48
		jump_time_to_peak = 0.35
		jump_time_to_descent = 0.35
	elif Global.time == 8:
		speed = 200
		climb_speed = 100
		
		jump_height = 32.0
		jump_time_to_peak = 0.3
		jump_time_to_descent = 0.3
		
		anim_pref = "o"
	elif Global.time == 9:
		speed = 100
		
		jump_height = 16.0
		jump_time_to_peak = 0.2
		jump_time_to_descent = 0.2
		
		can_climb = false
	elif Global.time == 10:
		#Death
		speed = 0.001
		jump_height = 0.001
		jump_time_to_descent = 0.002
		velocity = Vector2(0,0)
		death()
	
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

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

func on_time_changed():
	update_stats()

func death():
	if Global.max_coins != Global.current_coins:
		Global.restart_game()
		return
	
	can_move = false

func teleport(to: Vector2):
	set_position(to)

func is_player():
	return true
