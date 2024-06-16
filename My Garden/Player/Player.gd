extends RigidBody2D

onready var sprite = $AnimatedSprite

const TYPE = "Player"

const SPEED = 150
const MAX_SPEED = SPEED * 2

var motion = Vector2(0,0)
var teleport
var force_queue

var can_move = true

func _physics_process(_delta):
	calculate_motion()
	
func calculate_motion():
	if can_move:
		motion = Motion.get_input_motion(self)
	else:
		motion = Vector2()

func _integrate_forces(state):
	if motion.x + 0.1 < 0:
		sprite.set_flip_h(true)
	elif motion.x - 0.1 > 0:
		sprite.set_flip_h(false)
	
	if motion.x != 0:
		sprite.animation = "walk"
	elif motion.y != 0:
		sprite.animation = "walk"
	else:
		if get_global_mouse_position().x < position.x:
			if !sprite.flip_h:
				sprite.animation = "look"
			else:
				sprite.animation = "idle"
		elif get_global_mouse_position().x > position.x:
			if !sprite.flip_h:
				sprite.animation = "idle"
			else:
				sprite.animation = "look"
	
	if teleport != null:
		state.set_linear_velocity(Vector2())
		state.set_angular_velocity(0)
		
		state.transform.origin = teleport
		teleport = null
	elif force_queue != null:
		apply_central_impulse(force_queue)
		force_queue = null
	
	apply_central_impulse(motion)
	state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED)


func get_type():
	return TYPE
