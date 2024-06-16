extends RigidBody2D

onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var search = $SearchArea
onready var search_area_range = $SearchArea/CollisionShape2D
onready var timer = $Upgrade

const TYPE = "Enemy"

var skin = "Dog"

var min_search_range = 256
var max_search_range = 512
var search_range = 384

#var SPEEDS = {
#	"Dog": 75,
#	"Grandma": 25,
#	"Grandpa": 25,
#}

var min_speeds = {
	"Dog": 60,
	"Grandma": 15,
	"Grandpa": 15,
}

var max_speeds = {
	"Dog": 90,
	"Grandma": 50,
	"Grandpa": 50,
}

var SPEED = 50

var motion = Vector2(0,0)
var teleport
var force_queue

var life = 1
var stomach = 0.0
var trap_influence = ""

var performance_buffer = 0

var ldelta = 1
var lpdelta = 1

func _ready():
	randomize()
	sprite.animation = skin + "_idle"
	
	SPEED = randi()%(max_speeds[skin]-min_speeds[skin]+1)+min_speeds[skin]
	print("Speed: " + str(SPEED))
	
	search_range = randi()%(max_search_range-min_search_range)+min_search_range
	search_area_range.shape.radius = search_range
	print("Range: " + str(search_range))
	
	timer.start(randi()%6+10)

func _process(delta):
	ldelta = delta
	
	if life <= 0:
		return
	
	if stomach > 0:
		stomach -= delta

func _physics_process(delta):
	lpdelta = delta
	
	calculate_motion(delta)
	check_collisions()

func check_collisions():
	for body in get_colliding_bodies():
		_on_Enemy_body_entered(body)

func calculate_motion(delta):
	if performance_buffer > 0:
		performance_buffer -= 1
		return
	else:
		performance_buffer = 4
	
	motion = Vector2()
	
	if trap_influence == "Slime":
		return
	
	var target = position
	
	if trap_influence == "Door":
		target = position + Vector2(0,16)
		motion = Motion.get_target_motion(self,target,delta)
		return
	else:
		for pd in search.get_overlapping_bodies():
			if pd.has_method("_on_Golden_Donut_body_entered"):
				target = pd.position
				break
			elif pd.has_method("heal"):
				target = pd.position
	
	if target != null && stomach <= 0:
		if position.distance_to(target) <= search_range:
			if position.distance_to(target) <= 128:
				raycast.collide_with_areas = false
			else:
				raycast.collide_with_areas = true
			
			raycast.cast_to = target - position
			raycast.enabled = true
			if !raycast.is_colliding():
				motion = Motion.get_target_motion(self,target,delta)
				
				if trap_influence == "Boost":
					motion *= 3
				elif trap_influence == "Sand":
					motion /= 3
				elif trap_influence == "Oil":
					motion *=1.5
					motion = motion.rotated(45)
		else:
			raycast.enabled = false
	else:
		raycast.enabled = false

func _integrate_forces(_state):
	if life <= 0:
		return
	
	if motion.x < 0:
		sprite.flip_h = true
	elif motion.x > 0:
		sprite.flip_h = false
	
	if trap_influence == "" || trap_influence == "Door":
		if motion != Vector2():
			sprite.animation = skin + "_walk"
		else:
			sprite.animation = skin + "_idle"
	else:
		sprite.animation = skin + "_" + trap_influence
	
#	if teleport != null:
#		state.set_linear_velocity(Vector2())
#		state.set_angular_velocity(0)
#
#		state.transform.origin = teleport
#		teleport = null
#	elif force_queue != null:
#		apply_central_impulse(force_queue)
#		force_queue = null
	
	if trap_influence == "Slime":
		return
	
	apply_central_impulse(motion)
	#state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED,lpdelta)

func hit():
	stomach = 100
	Audio.play_sound("Death",false,"enemy")
	life -= 1
	Global.add_score(150)
	sprite.animation = skin + "_death"

func get_type():
	return TYPE

func set_trap_influence(ti):
	trap_influence = ti

func eat_gold():
	stomach = 3
	Global.add_score(100)

func _on_Enemy_body_entered(body):
	if stomach <= 0:
		if body.has_method("get_type"):
			if body.get_type() == "Player":
				stomach = 1
				body.hit()

func _on_AnimatedSprite_animation_finished():
	if life <= 0 && sprite.animation == str(skin + "_death"):
		queue_free()


func _on_Upgrade_timeout():
	if SPEED <= max_speeds[skin] - 3:
		SPEED += 3
		randi()%6+1
	
	if search_range <= max_search_range - 16:
		search_range += randi()%9+8
		search_area_range.shape.radius = search_range
	
	print("Increase")
	
	timer.start(randi()%6+10)
