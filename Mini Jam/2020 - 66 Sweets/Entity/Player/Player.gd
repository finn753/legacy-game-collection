extends RigidBody2D

onready var cooldown = $Cooldown
onready var i_timer = $Invincible
onready var sprite = $Sprite

const TYPE = "Player"

const SLOWDOWN = 0.75
var speed = 175 * SLOWDOWN
var MAX_SPEED = speed*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()

var teleport
var keep_avel = false
var keep_lvel = false

var force_queue

var buffer = Vector2(80,80)
var last_anchor = Vector2()

var moving = true
var occupied = false

var invincible = false

onready var tilemap = get_owner().get_node("TileMap")
onready var trap_indicator = get_owner().get_node("Trap Indicator")
var direction = Vector2(0,0)

func _ready():
	invincible = false
	last_anchor = position

func _physics_process(delta):
	if Global.scene == "Level":
		if tilemap == null || trap_indicator == null:
			pass
		else:
			var map_position = tilemap.world_to_map(position) - direction * 8
			if tilemap.get_cellv(map_position) == -1 || tilemap.get_cellv(map_position) == 0 || tilemap.get_cellv(map_position) == 1 || tilemap.get_cellv(map_position) == 3 || tilemap.get_cellv(map_position) == 4:
				trap_indicator.position = tilemap.map_to_world(map_position)
			else:
				print(String(tilemap.get_cellv(map_position)))
			
	sprite.animation = String(Global.health) + "_4"
	
	if Input.is_action_just_pressed("c"):
		if Global.selected_trap == Global.traps.size() - 1:
			Global.selected_trap = 0
		else:
			Global.selected_trap += 1
	
	if Global.scene == "Level" && Global.can_trap:
		if trap_indicator != null:
			if Input.is_action_just_pressed("action"):
				Sound.play_sound("place")
				Global.can_trap = false
				cooldown.wait_time = Global.wait_time[Global.selected_trap]
				cooldown.start()
				
				var r = Global.traps[Global.selected_trap]
				var t = load("res://Objects/Traps/" + r + "/" + r +".tscn").instance()
				t.position = trap_indicator.position
				t.set_name(r)
				get_owner().add_child_below_node(get_owner().get_node("YSort"),t)
				
				if Global.selected_trap == Global.traps.size() - 1:
					Global.selected_trap = 0
				else:
					Global.selected_trap += 1
	
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
	if moving:
		cmovement = Gmotion.get_touch_motion(self)
		
	cmovement = Gmotion.limit_speed(cmovement,speed) #Max Speed
	
	movement = cmovement #Set Movement
	
#	if movement.x < 0:
#		body.set_flip_h(true)
#		body_light.set_flip_h(true)
#		face.set_flip_h(true)
#	elif movement.x > 0:
#		body.set_flip_h(false)
#		body_light.set_flip_h(false)
#		face.set_flip_h(false)

func _integrate_forces(state):
	if occupied:
		apply_central_impulse(-state.linear_velocity)
		return
	
	apply_central_impulse(movement - state.linear_velocity*slowdown) #Movement - Slowdown
	state.linear_velocity = Gmotion.limit_speed(state.linear_velocity,MAX_SPEED) # Max Speed
	
	#Teleport
	if teleport != null:
		var xform = state.get_transform()
		state.set_transform(Gmotion.get_teleport(self,xform))
		teleport = null
	
#	#Set Anchor
#	if position.x > last_anchor.x - buffer.x && position.x < last_anchor.x + buffer.x && position.y > last_anchor.y - buffer.y && position.y < last_anchor.y + buffer.y:
#		pass
#	else:
#		var tm = get_owner().get_node("TileMap")
#		if tm != null:
#			var tmc = tm.world_to_map(position)
#
#			if tm.get_cellv(tmc) == -1 || tm.get_cellv(tmc) == 2 || tm.get_cellv(tmc) == 5 || tm.get_cellv(tmc) == 6:
#				pass
#			else:
#				last_anchor = position

func death():
	if !invincible:
		Global.health -= 1
		
		print(String(Global.health))
		
		if Global.health <= 0:
			Global.death()
		else:
			Sound.play_sound("death")
			invincible = true
			i_timer.start()

func get_TYPE():
	return TYPE


func _on_Cooldown_timeout():
	Global.can_trap = true


func _on_Invincible_timeout():
	invincible = false
