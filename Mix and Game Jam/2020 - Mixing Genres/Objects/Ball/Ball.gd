extends RigidBody2D

onready var audio = $AudioStreamPlayer2D

const type = "Ball"

const KICK = 2.5
const MAX_SPEED = 700

var force_queue
var teleport

puppet var slave_position = position

func _integrate_forces(state):
	if get_tree().network_peer != null:
		if get_network_master() != get_tree().get_network_unique_id():
			set_network_master(get_tree().get_network_unique_id())
	
	state.linear_velocity = Motion.limit_speed(state.linear_velocity,MAX_SPEED)
	
	if teleport != null:
		state.set_linear_velocity(Vector2())
		state.set_angular_velocity(0)
		
		state.transform.origin = teleport
		teleport = null
	
	if force_queue != null:
		apply_central_impulse(force_queue)
		force_queue = null
	
#	if get_tree().network_peer != null:
#		state.transform.origin = slave_position

remotesync func sync_ball(pos):
	slave_position = pos

remotesync func kick_ball(p,v):
	if get_tree().network_peer != null && teleport == null:
		teleport = p
	force_queue = v

func _on_Ball_body_entered(body):
#	rpc("sync_ball",position)
	audio.play(0)
	
	if body.has_method("get_type"):
		if body.type == "Player":
			if get_tree().network_peer != null:
				rpc("kick_ball",position,linear_velocity * KICK)
			else:
				kick_ball(position,linear_velocity*KICK)
#			rset("force_queue",linear_velocity * KICK)

func get_type():
	return type
