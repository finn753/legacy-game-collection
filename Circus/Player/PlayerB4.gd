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
var velocity = Vector2()
var appl_x = Vector2()
var appl_y = Vector2()

var jump = false

func _process(delta):
	get_input()

func _physics_process(delta):
	var snap = 8
	
	var vel_x = speed * movement_dir * gravity_normal.rotated(deg2rad(-90)) * delta
	
	var vel_y = Vector2(0,0)
	
	if jump:
		jump = false
		snap = 0
		vel_y = jump_velocity * gravity_normal * delta * 60
	else:
		vel_y = get_gravity() * delta * gravity_normal
	
#	yadd.x = stepify(yadd.x,0.1)
#	yadd.y = stepify(yadd.y,0.1)
	
	#print(yadd)
	
	velocity -= appl_x
	velocity += vel_y
	
	velocity = move_and_slide_with_snap(velocity,gravity_normal*snap,-gravity_normal,true)
	
	var old_vel = velocity
	velocity += vel_x
	velocity = move_and_slide_with_snap(velocity,gravity_normal*snap,-gravity_normal,true)
	
	appl_x = velocity - old_vel
	
	print(velocity)

func get_input():
	movement_dir = 0
	
	if Input.is_action_pressed("left"):
		movement_dir -= 1
	
	if Input.is_action_pressed("right"):
		movement_dir += 1
	
	if Input.is_action_just_pressed("up"):
		jump = true

func get_gravity():
	if velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity
