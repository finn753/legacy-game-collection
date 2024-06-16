extends RigidBody2D

onready var sprite = $AnimatedSprite

const TYPE = "Player"

const SPEED = 175
const MAX_SPEED = SPEED * 2

var motion = Vector2(0,0)
var teleport
var force_queue

enum TOOLS {NONE,DETECTOR}
var s_tool = TOOLS.NONE

func _physics_process(delta):
	calculate_motion()
	
func calculate_motion():
	motion = Vector2()
	
	motion = Motion.get_input_motion(self)

func _integrate_forces(state):
	if motion.x + 0.1 < 0:
		sprite.set_flip_h(true)
	elif motion.x - 0.1 > 0:
		sprite.set_flip_h(false)
	
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
