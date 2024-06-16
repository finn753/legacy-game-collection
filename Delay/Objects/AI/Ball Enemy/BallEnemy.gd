extends KinematicBody2D

onready var init_pos = position

export var move_speed = 150

var velocity := Vector2.ZERO
var playing = true

export(NodePath) var target_path
onready var target = get_node(target_path)

export var goal_direction = 1

export var jump_height = 50.0
export var jump_time_to_peak = 0.35
export var jump_time_to_descent = 0.3

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _ready():
	target.connect("teleport",self,"reset")

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	calculate_movement()
	
	var snap_modify = 0
	if velocity.y >= 0:
		snap_modify = 8
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN * snap_modify, Vector2.UP)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.has_method("kick"):
			collision.collider.kick(-collision.normal * 100)

func get_gravity() -> float:
	if velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity

func calculate_movement():
	if !playing || Global.minigame != "Ballgame":
		velocity.x = 0
		return
	
	var direction = 0
	
	if (goal_direction > 0 && target.position.x > position.x) || (goal_direction < 0 && target.position.x < position.x):
		var distance = (target.position.x - position.x) * goal_direction
		if distance > 8:
			direction = goal_direction
		if distance > 32 && target.linear_velocity.y < 0 && is_on_floor():
			jump()
	else:
		if target.position.y < position.y - 10 || (position.x - target.position.x) * goal_direction > 24:
			direction = -goal_direction
	
	velocity.x = direction * move_speed

func jump(free = false):
	$AudioStreamPlayer2D.play(0)
	velocity.y = jump_velocity

func set_boost(act):
	if act:
		if velocity.y < 0:
			#velocity.y *= 2
			velocity.y += jump_velocity

func reset():
	velocity = Vector2(0,0)
	#position = init_pos

func is_enemy():
	return true
