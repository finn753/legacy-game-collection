extends RigidBody2D

onready var sprite = $AnimatedSprite
onready var sound = $SoundManager
onready var camera = $Camera2D
onready var animation = $AnimationPlayer
onready var animation2 = $AnimationPlayer2

const TYPE = "Player"

const SPEED = 100
const MAX_SPEED = SPEED * 4

var motion = Vector2(0,0)
var teleport
var force_queue

var health = 5
var max_health = 4
var invincible = 0.0

var trap_influence = ""

func _ready():
	sprite.animation = "Spawn"

func _process(delta):
	if invincible > 0:
		invincible -= delta

func _physics_process(delta):
	calculate_motion(delta)

func calculate_motion(delta):
	motion = Vector2()
	
	if Global.mouse_in_window:
		motion = Motion.get_target_motion(self,get_global_mouse_position(),delta)
		
		if trap_influence == "Boost":
			motion *= 3
		elif trap_influence == "Sand" || trap_influence == "Slime":
			motion /= 3
		elif trap_influence == "Oil":
			motion *=1.5
			motion = motion.rotated(deg2rad(45))
		
		if Input.is_action_pressed("invert"):
			Global.invert_placement = true
		else:
			Global.invert_placement = false
	
	Global.player_pos = position

func _integrate_forces(_state):
	if motion != Vector2(0,0):
		sprite.rotation_degrees = rad2deg(Vector2(1,0).angle_to(motion))
	
#	if teleport != null:
#		state.set_linear_velocity(Vector2())
#		state.set_angular_velocity(0)
#
#		state.transform.origin = teleport
#		teleport = null
#	elif force_queue != null:
#		apply_central_impulse(force_queue)
#		force_queue = null
	
	apply_central_impulse(motion)
	#state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED,lpdelta)

func hit():
	if invincible <= 0:
		invincible = 1
		
		if health > 0:
			sound.play_sound("Hit",true)
			animation.play("Hit")
			health -= 1
		
		sprite.animation = String(health) + "hit"

func eat_gold():
	heal()

func heal():
	Global.add_score(50)
	if health <= 5:
		sound.play_sound("Heal")
		health += 1
		sprite.animation = String(health)
		animation2.play("Heal")

func set_trap_influence(ti):
	trap_influence = ti
	if ti == "Boost" || ti == "Oil" || ti == "Ice" :
		animation2.play("Boost")
	elif ti == "Sand" || ti == "Slime":
		animation2.play("Slow")

func get_type():
	return TYPE

func _on_AnimatedSprite_animation_finished():
	if health <= 0:
		Global.current_trap = ""
		Global.score = 0
		Global.change_scene("res://World/Sugaree City/Sugaree City.tscn")


#func _on_Player_body_entered(body):
#	if body.has_method("get_type") && body.get_type() == "Enemy":
#		return
#	animation.play("Collision")
