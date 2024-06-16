extends RigidBody2D

const SLOWDOWN = 0.75

func _integrate_forces(state):
	apply_central_impulse(-state.linear_velocity*SLOWDOWN)
