extends RigidBody2D

onready var area = $Area2D
onready var sprite = $Sprite

const TYPE = "Enemy"
const HUNGER = 1

var saturation = 0

var sprites = ["Grandma","Grandpa","Girl","Boy","Dog"]
var speeds =  [50       ,50       ,100    ,100   ,150]
var type = randi()%int(sprites.size())

const SLOWDOWN = 0.75
var speed = speeds[type] * SLOWDOWN
var MAX_SPEED = speed*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()

var teleport
var keep_avel = false
var keep_lvel = false

var force_queue

var moving = true
var occupied = false

var respawn = Vector2()


func _ready():
	respawn = position
	
	randomize()
	type = randi()%int(sprites.size())
	speed = speeds[type] * SLOWDOWN
	MAX_SPEED = speed*2
	sprite.texture = load("Entity/Enemy/" + sprites[type] + ".png")

func _physics_process(delta):
	if saturation > 0:
		saturation -= HUNGER * delta
	if saturation < 0:
		saturation = 0
	
	for body in get_colliding_bodies():
		if body.has_method("get_TYPE"):
			if body.TYPE == "Player":
				body.death()
				saturation = 5
	
	calculate_movement()
	
func calculate_movement():
	cmovement = Vector2(0,0)
	
	if saturation <= 0:
		for p in area.get_overlapping_bodies():
			if p.has_method("get_TYPE"):
				if p.TYPE == "Donut":
					var angle = Vector2(1,0).angle_to(p.position - position)
					cmovement = Vector2(speed,0).rotated(angle)
					break
				elif p.TYPE == "Player":
					var angle = Vector2(1,0).angle_to(p.position - position)
					cmovement = Vector2(speed,0).rotated(angle)
		
	cmovement = Gmotion.limit_speed(cmovement,speed) #Max Speed
	
	movement = cmovement #Set Movement
	
	if movement.x < 0:
		sprite.set_flip_h(false)
	elif movement.x > 0:
		sprite.set_flip_h(true)

func _integrate_forces(state):
	if occupied:
		apply_central_impulse(-state.linear_velocity)
		return
	
	apply_central_impulse(movement - state.linear_velocity*slowdown) #Movement - Slowdown
	state.linear_velocity = Gmotion.limit_speed(state.linear_velocity,MAX_SPEED) # Max Speed
	
	#Force Queue
	if force_queue != null:
		apply_central_impulse(force_queue)
		force_queue = null
	
	#Teleport
	if teleport != null:
		var xform = state.get_transform()
		state.set_transform(Gmotion.get_teleport(self,xform))
		teleport = null

func death():
	Sound.play_sound("hit")
	teleport = respawn
	Global.score += 25

func get_TYPE():
	return TYPE


func _on_Area2D_body_entered(body):
	if body.has_method("get_TYPE"):
		if body.TYPE == "Player":
			Sound.play_sound("point")
			Global.score += 10
