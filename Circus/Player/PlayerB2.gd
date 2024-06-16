extends KinematicBody2D

export var speed = 12500

export var jump_height = 64.0
export var jump_time_to_peak = 0.3
export var jump_time_to_descent = 0.35

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var gravity_normal = Vector2(0,1).rotated(deg2rad(0))

var movement_dir = 0
var vel_x = Vector2()
var vel_y = Vector2()

var jump = false

func _process(delta):
	get_input()

func _physics_process(delta):
	var snap = 8
	
	vel_x += speed * movement_dir * gravity_normal.rotated(deg2rad(-90)) * delta
	
	var yadd = Vector2(0,0)
	
	if jump:
		jump = false
		snap = 0
		yadd = jump_velocity * gravity_normal * delta * 60
	else:
		yadd = get_gravity() * delta * gravity_normal
	
	yadd.x = stepify(yadd.x,0.1)
	yadd.y = stepify(yadd.y,0.1)
	
	#print(yadd)
	
	vel_y += yadd
	
	vel_x = move_and_slide_with_snap(vel_x,gravity_normal*snap,-gravity_normal,true) * gravity_normal
	vel_y = move_and_slide_with_snap(vel_y,gravity_normal*snap,-gravity_normal,true) * gravity_normal
	
	
	
	print(str(vel_x) + " | " + str(vel_y))

func get_input():
	movement_dir = 0
	
	if Input.is_action_pressed("left"):
		movement_dir -= 1
	
	if Input.is_action_pressed("right"):
		movement_dir += 1
	
	if Input.is_action_just_pressed("up"):
		jump = true

func get_gravity():
	if vel_y.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity
