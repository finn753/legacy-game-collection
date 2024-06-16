extends Area2D

export var direction = Vector2(0,1)
export var force = 14336

export var particle_gravity = 196
export var scale_amount = 4.0
export var amount = 5

onready var particle = $CPUParticles2D

func _ready():
	particle.gravity = Vector2(particle_gravity,particle_gravity)*direction
	particle.emitting = true
	particle.amount = amount
	particle.scale_amount = scale_amount
	
	gravity_vec = direction
	gravity = force

func _physics_process(delta):
	particle.gravity = Vector2(particle_gravity,particle_gravity)*direction
	gravity_vec = direction
