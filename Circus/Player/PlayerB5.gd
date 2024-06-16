extends KinematicBody2D

onready var rot_tween = $RotTween

export var speed = 12500

export var jump_height = 64.0
export var jump_time_to_peak = 0.3
export var jump_time_to_descent = 0.35

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var DEFAULT_GRAVITY = Vector2(0,1).rotated(deg2rad(0)) #TODO Make Const
var gravity_influence = {}
var gravity_normal = DEFAULT_GRAVITY
var gravity_zchanged = false

var movement_dir = 0
var velocity = Vector2()
var appl_x = Vector2()
var appl_y = Vector2()

var jump = false

func _process(delta):
	get_input()
	calculate_sprite()

func _physics_process(delta):
	calculate_gravity_normal()
	
	var snap = 8
	
	var vel_x = speed * movement_dir * gravity_normal.rotated(deg2rad(-90)) * delta
	
	var vel_y = Vector2(0,0)
	
	if jump:
		jump = false
		snap = 0
		vel_y = jump_velocity * gravity_normal * delta * 40
	else:
		vel_y = get_gravity() * delta * gravity_normal
	
#	vel_x.x = stepify(vel_x.x,0.1)
#	vel_x.y = stepify(vel_x.y,0.1)
#
#	vel_y.x = stepify(vel_y.x,0.1)
#	vel_y.y = stepify(vel_y.y,0.1)
	
	var mod = Vector2(1,1)
	
	if gravity_normal.x == 0 || gravity_normal.y == 0:
		mod = gravity_normal
	
	appl_x = move_and_slide_with_snap(velocity + vel_x,gravity_normal*snap,-gravity_normal,true) * mod.abs()
	appl_y = move_and_slide_with_snap(velocity + vel_y,gravity_normal*snap,-gravity_normal,true) * mod.abs()
	
	velocity = appl_y
	
	if is_on_floor():
		velocity = gravity_normal

func get_input():
	movement_dir = 0
	
	if Input.is_action_pressed("left"):
		movement_dir -= 1
	
	if Input.is_action_pressed("right"):
		movement_dir += 1
	
	if Input.is_action_just_pressed("up"):
		jump = true

func calculate_gravity_normal():
	if gravity_influence.empty():
		gravity_normal = DEFAULT_GRAVITY
		return
	
	var mk = ""
	for k in gravity_influence.keys():
		if mk == "":
			mk = k
			continue
		
		if gravity_influence[k][0] > gravity_influence[mk][0]:
			mk = k
	
	var n_g = gravity_influence[mk][1]
	if n_g != gravity_normal:
		gravity_normal = n_g
		gravity_zchanged = true

func calculate_sprite():
	var n_rot = rad2deg(gravity_normal.angle()) - 90
		
	if rotation_degrees != n_rot && !rot_tween.is_active() || gravity_zchanged:
		gravity_zchanged = false
		var dist = abs(n_rot - rotation_degrees)
		
		if dist > 200:
			if n_rot < rotation_degrees:
				rotation_degrees -= 360
			else:
				rotation_degrees +=360
		
		rot_tween.remove_all()
		rot_tween.interpolate_property(self,"rotation_degrees",null,n_rot,0.2,Tween.TRANS_SINE,Tween.EASE_OUT)
		rot_tween.start()

func get_gravity():
	var move_angle = rad2deg(velocity.angle_to(gravity_normal))
	
	if move_angle > 160 || move_angle < -160:
		return jump_gravity
	else:
		return fall_gravity
