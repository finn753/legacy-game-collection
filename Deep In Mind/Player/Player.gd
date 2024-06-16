extends RigidBody2D

onready var sprite = $AnimatedSprite
onready var audio = $AudioStreamPlayer

const TYPE = "Player"

const SPEED = 100
const MAX_SPEED = SPEED * 2

var touch_motion = false

var motion = Vector2(0,0)
var teleport
var force_queue

func _physics_process(delta):
	calculate_motion()
	
func calculate_motion():
	motion = Vector2()
	if touch_motion:
		motion = Motion.get_target_motion(self,get_global_mouse_position())
	else:
		motion = Motion.get_input_motion(self)

func _integrate_forces(state):
	if motion.x + 0.1 < 0:
		sprite.set_flip_h(true)
	elif motion.x - 0.1 > 0:
		sprite.set_flip_h(false)
	
	if motion.x != 0:
		sprite.animation = "walk"
		if !audio.playing:
			pass
			#audio.play(0)
	elif motion.y != 0:
		sprite.animation = "walk"
		if !audio.playing:
			pass
			#audio.play(0)
	else:
		sprite.animation = "default"
	
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


func _on_Movement_button_down():
	touch_motion = true

func _on_Movement_button_up():
	touch_motion = false
