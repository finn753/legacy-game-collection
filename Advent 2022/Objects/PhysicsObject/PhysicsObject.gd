extends KinematicBody2D

onready var rot_tween = $RotTween
onready var spawn_pos = position
onready var anim = $AnimationPlayer

export var jump_height = 64.0
export var jump_time_to_peak = 0.3
export var jump_time_to_descent = 0.35
export var equal_gravity = true
export var clamp_speed = 512

export var can_gravity = true
export var can_wind = true
export var gravity_in_wind = true

export var breakable = false
export var break_delay = 1.0
export var respawn = true
export var respawn_pos = Vector2()
export var reset_to_spawn_pos = true

export var following = false
export(NodePath) var follow_node_path
var follow_obj

var jump_velocity
var jump_gravity
var fall_gravity

var DEFAULT_GRAVITY = Vector2(0,1).rotated(deg2rad(0)) #TODO Make Const
var gravity_influence = {}
var gravity_normal = DEFAULT_GRAVITY
var gravity_zchanged = false
var wind_influence = {}

var velocity = Vector2()

var jump = false

enum BREAK_STATES {Stable,Breaking,Broken}
var break_state = BREAK_STATES.Stable

func _ready():
	if following:
		if follow_node_path == null:
			following = false
		else:
			follow_obj = get_node(follow_node_path)
	
	if equal_gravity:
		jump_time_to_descent = jump_time_to_peak
	
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _physics_process(delta):
	var snap = 8
	calculate_sprite()
	
	if following && break_state != BREAK_STATES.Broken:
		position = follow_obj.global_position
		velocity = Vector2(0,0)
#		if add_parent_pos:
#			position += follow_obj.get_parent().position
		return
	
	if jump:
		jump = false
		snap = 0
		velocity.y = jump_velocity
	
	var w_vec = calculate_wind()
	
	velocity.x = 0
	velocity.y += get_gravity() * delta
	
	if can_wind && w_vec != Vector2(0,0):
		if w_vec.y < 0:
			velocity = w_vec
		else:
			if gravity_in_wind:
				velocity += w_vec
			else:
				velocity = w_vec
	
#	if w_vec != Vector2(0,0) && can_wind:
#		velocity = w_vec
#
#	if w_vec.y >= 0:
#		velocity.y += get_gravity() * delta
	
	calculate_gravity_normal()
	var grav_rot = gravity_normal.angle_to(Vector2(0,1))
	
	velocity.y = clamp(velocity.y,-clamp_speed,clamp_speed)
	
	if breakable && break_state != BREAK_STATES.Broken:
		velocity = Vector2(0,0)
	
	position += velocity.rotated(grav_rot) * delta

func calculate_gravity_normal():
	var n_g = Vector2(0,0)
	
	if gravity_influence.empty() || !can_gravity:
		n_g = DEFAULT_GRAVITY
	else:
		var sum = Vector2()
		var d = 0
		
		for k in gravity_influence.keys():
			sum += gravity_influence[k][1]
			d += 1
		
		n_g = (sum/d).normalized()
		
	if n_g != gravity_normal:
		gravity_normal = (15*gravity_normal + n_g)/16
		gravity_zchanged = true

func calculate_sprite():
	if break_state == BREAK_STATES.Breaking:
		if !anim.is_playing():
			anim.play("Shake")
	else:
		anim.play("RESET")
	
#	var n_rot = rad2deg(gravity_normal.angle()) - 90
#	rotation_degrees = n_rot

func calculate_wind() -> Vector2:
	var wind_vec = Vector2(0,0)
	
	for v in wind_influence:
		wind_vec += wind_influence[v]
	
	return wind_vec

func trigger_break():
	if !breakable || break_state != BREAK_STATES.Stable:
		return
	
	break_state = BREAK_STATES.Breaking
	$Countdown.start(break_delay)

func despawn():
	if !respawn:
		queue_free()
		return
	
	break_state = BREAK_STATES.Stable
	
	if reset_to_spawn_pos:
		position = spawn_pos
	else:
		position = respawn_pos

func get_gravity():
	if velocity.y < 0:
		return jump_gravity
	return fall_gravity

func get_vel():
	return velocity

func force_jump():
	if !jump:
		jump = true
		return true
	return false

func _on_Countdown_timeout():
	break_state = BREAK_STATES.Broken
