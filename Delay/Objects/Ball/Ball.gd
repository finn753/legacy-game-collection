extends RigidBody2D

signal teleport

onready var min_height = position.y
onready var start_pos = position

onready var audio = $AudioStreamPlayer2D
onready var sprite = $Sprite
onready var tween = $Tween

export var horizontal_border = Vector2(0,1)

var teleport
var boost = false
var emit_teleport = -1

func _ready():
	$Timer.start()

func bounce_ball():
	audio.play()
	$Timer.start()
	apply_central_impulse(Vector2(0,-250))
	animate_hit()

func rescue():
	bounce_ball()

func _physics_process(delta):
	if emit_teleport == 0:
		emit_signal("teleport")
		emit_teleport = -1
	elif emit_teleport > 0:
		emit_teleport -= 1

func _integrate_forces(state):
	if position.y > min_height + 2:
		state.transform.origin.y = min_height
		if linear_velocity.y > 0:
			linear_velocity.y = 0
	
	if position.x < horizontal_border.x:
		state.transform.origin.x = horizontal_border.x
		if linear_velocity.x < 0:
			linear_velocity.x = 64
	elif position.x > horizontal_border.y:
		state.transform.origin.x = horizontal_border.y
		if linear_velocity.x > 0:
			linear_velocity.x = -64
	
	if boost:
		boost = false
		
		if linear_velocity.y < 0:
			linear_velocity *= 2
	
	if teleport != null:
		state.transform.origin = teleport
		linear_velocity = Vector2(0,0)
		teleport = null
		emit_teleport = 10

func set_boost(act):
	if act:
		boost = true

func kick(vel):
	audio.play()
	apply_central_impulse(vel)
	Time.change_factor("ball",1)
	$Reset.start()
	animate_hit()

func animate_hit():
	tween.remove_all()
	tween.interpolate_property(sprite,"scale",Vector2(0.75,0.75),Vector2(1,1),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()

func _on_Ball_body_entered(body):
	bounce_ball()

func _on_Timer_timeout():
	bounce_ball()

func _on_Reset_timeout():
	Time.change_factor("ball",0)
