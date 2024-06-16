extends RigidBody2D

onready var sprite = $Sprite

const type = "Player"

const SLOWDOWN = 0.75
var speed = 300 * SLOWDOWN
var MAX_SPEED = speed*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()
var teleport

var touching = false
var occupied = false

func _physics_process(delta):
	calculate_movement()
	
func calculate_movement():
	cmovement = Vector2(0,0)
	
	if occupied:
		movement = cmovement
		slowdown = 1
		return
	else:
		slowdown = SLOWDOWN
	
	#Movement
	if touching:
		cmovement = Motion.get_touch_motion(self)
	else:
		cmovement = Motion.get_input_motion(self)
		
	cmovement = Motion.limit_speed(cmovement,speed) #Max Speed
	
	movement = cmovement #Set Movement
	
	if movement.x < 0:
		sprite.set_flip_h(false)
	elif movement.x > 0:
		sprite.set_flip_h(true)
	
	if movement == Vector2():
		sprite.animation = "idle"
	else:
		sprite.animation = "walk"

func _integrate_forces(state):
	apply_central_impulse(movement - state.linear_velocity*slowdown) #Movement - Slowdown
	state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED) # Max Speed
		
	#Teleport
	if teleport != null:
		var xform = state.get_transform()
		state.set_transform(Motion.get_teleport(self,xform))
		teleport = null

func _on_Movement_Button_button_down():
	touching = true

func _on_Movement_Button_button_up():
	touching = false
	
func get_type():
	return type
