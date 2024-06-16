extends RigidBody2D

onready var body = $Body
onready var area = $Area2D

const TYPE = "Girl"

const SLOWDOWN = 0.75
const SPEED = 400 * SLOWDOWN
const MAX_SPEED = SPEED*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()
var teleport

var scared = false
var run_pos = position

var occupied = false

func _ready():
	body.playing = true
	
	if position.x > 1024/2:
		body.set_flip_h(true)
		#face.set_flip_h(true)
		
	if Global.scene == "Floor":
		if Global.progress <= 0:
			run_pos = Vector2(736,144)
		else:
			queue_free()
	
	if Global.scene == "Encounter":
		run_pos = Vector2(992,544)
		
	if Global.scene == "Garden":
		run_pos = Vector2(1024,600)
	
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
	for p in area.get_overlapping_bodies():
		if p.has_method("get_TYPE"):
			if p.TYPE == "Player":
				if !scared:
					scared = true
					Global.player_light = true
	
	if scared:
		if run_pos - Vector2(5,5) <= position && run_pos + Vector2(5,5) >= position:
			scared = false
			
			if Global.scene == "Floor" && Global.progress == 0:
				Sound.play_point()
				Global.progress = 1
				queue_free()
		else:
			var angle = Vector2(1,0).angle_to(run_pos-position)
			cmovement = Vector2(SPEED,0).rotated(angle)
	
	cmovement = Gmotion.limit_speed(cmovement,SPEED) #Max Speed
	
	movement = cmovement #Set Movement
	
	if movement.x < 0:
		body.set_flip_h(true)
		#face.set_flip_h(true)
	elif movement.x > 0:
		body.set_flip_h(false)
		#face.set_flip_h(false)

func _integrate_forces(state):
	apply_central_impulse(movement - state.linear_velocity*slowdown) #Movement - Slowdown
	state.linear_velocity = Gmotion.limit_speed(state.linear_velocity,MAX_SPEED) # Max Speed
		
	#Teleport
	if teleport != null:
		var xform = state.get_transform()
		state.set_transform(Gmotion.get_teleport(self,xform))
		teleport = null

func get_TYPE():
	return TYPE
