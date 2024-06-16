extends RigidBody2D

onready var body = $Body
onready var body_light = $"Body Light"
onready var face = $Face

const TYPE = "Player"

const SLOWDOWN = 0.75
var speed = 200 * SLOWDOWN
var MAX_SPEED = speed*2

var slowdown = SLOWDOWN

var cmovement = Vector2()
var movement = Vector2()
var teleport

var touching = false
var occupied = false

onready var tsd = get_owner().get_node("TileMap2")

func _ready():
	body.playing = true
	body_light.playing = true
	face.playing = true
	
	if Global.progress < 0:
		if Global.scene == "Floor":
			Global.progress = 0
	
	if Global.scene == "Garden" && Global.progress == 2:
		Global.progress = 3
	
	if Global.scene == "Labor" && Global.progress == 3:
		Sound.play_point()
		Global.progress = 4
	
	if Global.scene == "Maze" && Global.progress == 5:
		Global.progress = 6
		
	if Global.scene == "Lightning" && Global.progress == 6:
		Sound.play_point()
		Global.progress = 7
		
	if Global.scene == "Hide" && Global.progress == 7:
		Sound.play_point()
		Global.progress = 8
		
	if Global.scene == "Hide2" && Global.progress == 8:
		Sound.play_point()
		Global.progress = 9
		
	if Global.scene == "Brew" && Global.progress == 9:
		Global.progress = 10
	
	if Global.scene == "Spawn":
		if Global.progress >= 0:
			position = Vector2(928,224)
			
	if Global.scene == "Floor":
		if Global.progress >= 1:
			position = Vector2(736,224)
			
	if Global.scene == "Encounter":
		if Global.progress >= 2:
			position = Vector2(928,224)
	
	if Global.scene == "Garden":
		if Global.progress >= 4:
			position = Vector2(928,224)
	
	if Global.scene == "Labor":
		if Global.progress >= 5:
			position = Vector2(992,224)
	
	if Global.scene == "Maze":
		if Global.progress >= 7:
			position = Vector2(928,224)
			
	if Global.scene == "Lightning":
		if Global.progress >= 8:
			position = Vector2(992,224)
			
	if Global.scene == "Hide":
		if Global.progress >= 9:
			position = Vector2(928,224)
			
	if Global.scene == "Hide2":
		if Global.progress >= 10:
			position = Vector2(992,224)
			
	if Global.scene == "Run":
		speed = 400 * SLOWDOWN
		MAX_SPEED = speed * 2

func _physics_process(delta):
	if Global.scene == "Run":
		Gmotion.touch_mode = 1
	else:
		Gmotion.touch_mode = 0
	
	if tsd != null:
		if tsd.get_cellv(tsd.world_to_map(position)/4) == 3:
			tsd.set_cellv(tsd.world_to_map(position)/4,7)
	
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
		cmovement = Gmotion.get_touch_motion(self)
	else:
		cmovement = Gmotion.get_input_motion(self)
		
	cmovement = Gmotion.limit_speed(cmovement,speed) #Max Speed
	
	movement = cmovement #Set Movement
	
	if movement.x < 0:
		body.set_flip_h(true)
		body_light.set_flip_h(true)
		face.set_flip_h(true)
	elif movement.x > 0:
		body.set_flip_h(false)
		body_light.set_flip_h(false)
		face.set_flip_h(false)

func _integrate_forces(state):
	apply_central_impulse(movement - state.linear_velocity*slowdown) #Movement - Slowdown
	state.linear_velocity = Gmotion.limit_speed(state.linear_velocity,MAX_SPEED) # Max Speed
		
	#Teleport
	if teleport != null:
		var xform = state.get_transform()
		state.set_transform(Gmotion.get_teleport(self,xform))
		teleport = null

func _on_Player_body_entered(body):
	print("b")
	if body.has_method("get_TYPE"):
		if body.TYPE == "Ghostbuster":
			Global.death()

func _on_Movement_Button_button_down():
	touching = true

func _on_Movement_Button_button_up():
	touching = false
	
func get_TYPE():
	return TYPE
