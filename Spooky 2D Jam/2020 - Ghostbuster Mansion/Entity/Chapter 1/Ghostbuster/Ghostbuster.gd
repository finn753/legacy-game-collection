extends RigidBody2D

onready var body = $Body
onready var face = $Face
onready var area = $Area2D

const TYPE = "Ghostbuster"

const SLOWDOWN = 0.75
const SPEED = 400 * SLOWDOWN
const MAX_SPEED = SPEED*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()
var teleport

var occupied = false
var target_pos

func _ready():
	target_pos = null
	
	body.playing = true
	face.playing = true
	
	if position.x > 1024/2:
		body.set_flip_h(true)
		face.set_flip_h(true)

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
	if Global.player_light:
		var player_pos = get_parent().get_node("Player").position
		target_pos = player_pos
	else:
		for p in area.get_overlapping_bodies():
			if p.has_method("get_TYPE"):
				if p.TYPE == "Player":
					target_pos = p.position
	
	if target_pos != null:
		if target_pos - Vector2(5,5) <= position && target_pos + Vector2(5,5) >= position:
			target_pos = null
			if Global.progress == 1 && Global.scene == "Encounter":
				Sound.play_point()
				Global.progress = 2
		else:
			var angle = Vector2(1,0).angle_to(target_pos-position)
			cmovement = Vector2(SPEED,0).rotated(angle)
	
	cmovement = Gmotion.limit_speed(cmovement,SPEED) #Max Speed
	
	movement = cmovement #Set Movement
	
	if movement.x < 0:
		body.set_flip_h(true)
		face.set_flip_h(true)
	elif movement.x > 0:
		body.set_flip_h(false)
		face.set_flip_h(false)

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
