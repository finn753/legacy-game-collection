extends RigidBody2D

export var speed = 135
export var power = 2

onready var particles = $CPUParticles2D

func _physics_process(delta):
	rotation_degrees += speed*delta
	
	if speed > 0:
		particles.orbit_velocity = 1
	elif speed < 0:
		particles.orbit_velocity = -1
	else:
		particles.orbit_velocity = 0

#func _on_Spinner_body_entered(body):
#	if body.has_method("get_type"):
#		if body.type == "Player":
#			body.force_queue = body.linear_velocity.rotated(deg2rad(speed)) * power
