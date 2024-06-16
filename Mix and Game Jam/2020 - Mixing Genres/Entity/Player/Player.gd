extends RigidBody2D

onready var name_label = $Name/Name
onready var sprite = $Sprite
onready var cooldown = $Cooldown

const type = "Player"

export var is_master = true
export var control = "wasd"
export var character = 0
export var id = 0
export var nickname = ""

var team

const PLAYER_SPEED = 300
const AI_SPEED = 150

var SPEED = PLAYER_SPEED
const MAX_SPEED = PLAYER_SPEED * 2

var motion = Vector2(0,0)
var teleport
var force_queue
var target
var ai_pause = true

puppet var slave_position = Vector2()
puppet var slave_motion = Vector2()

var special_sprite = false

func _ready():
	name = str(id)
	set_network_master(id)

func _physics_process(delta):
	check_despawn()
	if Global.player_data.has(id) || id < 0:
		reload_data()
		calculate_motion()
	
func calculate_motion():
	motion = Vector2()
	SPEED = PLAYER_SPEED
	
	if get_tree().network_peer == null || is_network_master():
		if control == "touchPC":
			#Mouse Control
			motion = Motion.get_touch_motion(self)
		elif control == "touchML":
			#Mobile Control
			pass
		elif control == "touchMR":
			#Mobile Control
			pass
		elif control == "ai":
			if !ai_pause:
				SPEED = AI_SPEED
				motion = Motion.get_target_motion(self,target)
		else:
			motion = Motion.get_input_motion(control,self)
	
		if get_tree().network_peer != null:
			rset_unreliable('slave_position', position)
			rset('slave_motion', motion)

func _integrate_forces(state):
	if motion.x < 0:
		sprite.set_flip_h(false)
	elif motion.x > 0:
		sprite.set_flip_h(true)
	
	if teleport != null:
		Sound.play_sound("Start")
		
		state.set_linear_velocity(Vector2())
		state.set_angular_velocity(0)
		
		state.transform.origin = teleport
		slave_position = teleport
		target = teleport
		teleport = null
	elif force_queue != null:
		apply_central_impulse(force_queue)
		force_queue = null
	
	if is_master:
		apply_central_impulse(motion)
		state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED)
	else:
		apply_central_impulse(slave_motion)
		state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED)
		state.transform.origin = slave_position
		
	if get_tree().network_peer != null:
		if get_tree().is_network_server():
			if id >= 0:
				Net.update_position(id,position)

func reload_data():
	if id >= 0:
		nickname = Global.player_data[id]["name"]
		control = Global.player_data[id]["control"]
		character = Global.player_data[id]["character"]
	
	if nickname != name_label.text:
		name_label.text = nickname
		Net.update_name(id,nickname)
	
	if Global.sprites[character] != sprite.animation:
		sprite.animation = Global.sprites[character]
		Net.update_skin(id,character)

func check_despawn():
	if !Global.player_data.has(id) && id >= 0:
		queue_free()

func get_type():
	return type

func _on_Cooldown_timeout():
	ai_pause = false
