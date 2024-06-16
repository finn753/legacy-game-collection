extends KinematicBody2D

export var speed = 12500

export var jump_height = 50.0
export var jump_time_to_peak = 0.35
export var jump_time_to_descent = 0.3

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var gravity_normal = Vector2(0,1).rotated(deg2rad(90))

var movement_dir = 0
var velocity = Vector2()
var old_x_vel = Vector2()

var jump = false

func _process(delta):
	get_input()

func _physics_process(delta):
	velocity -= old_x_vel
	old_x_vel = speed * movement_dir * gravity_normal.rotated(deg2rad(-90)) * delta
	velocity += old_x_vel
	
	if jump:
		jump = false
		velocity += jump_velocity * gravity_normal * delta * 80
	else:
		velocity += get_gravity() * gravity_normal * delta
	
	velocity = move_and_slide(velocity,-gravity_normal)

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
