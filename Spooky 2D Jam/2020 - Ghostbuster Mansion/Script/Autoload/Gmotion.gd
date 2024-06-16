extends Node

var touch_mode = 0

func limit_speed(speed: Vector2,max_speed):
	if speed.x > max_speed:
		speed.x = max_speed
	
	if speed.x < -max_speed:
		speed.x = -max_speed
	
	if speed.y > max_speed:
		speed.y = max_speed
	
	if speed.y < -max_speed:
		speed.y = -max_speed
	
	return speed
	
func get_teleport(p,xform):
	if !p.keep_lvel:
		p.set_linear_velocity(Vector2(0,0))
	
	if !p.keep_avel:
		p.set_angular_velocity(0)
	
	xform.origin.x = p.teleport.x
	xform.origin.y = p.teleport.y
	
	return xform
	
func get_input_motion(p):
	var direction = Vector2(0,0)
	var motion = Vector2(0,0)
	
	if Input.is_action_pressed("left"):
		direction.x -= 1
		motion = Vector2(p.speed,0)
		
	if Input.is_action_pressed("right"):
		direction.x += 1
		motion = Vector2(p.speed,0)
		
	if Input.is_action_pressed("up"):
		direction.y -= 1
		motion = Vector2(p.speed,0)
		
	if Input.is_action_pressed("down"):
		direction.y += 1
		motion = Vector2(p.speed,0)
	
	if direction == Vector2(0,0):
		motion = Vector2(0,0)
	
	var angle = Vector2(1,0).angle_to(direction)
	return motion.rotated(angle)
	
func get_touch_motion(p):
	var touch_pos = get_viewport().get_mouse_position()
	var angle
	if touch_mode == 0:
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - p.position))
	elif touch_mode == 1:
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - Vector2(p.position.x,p.get_viewport_rect().size.y/2)))
	else:
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - p.get_viewport_rect().size/2))
	return Vector2(p.speed,0).rotated(deg2rad(angle))
	
#Vector2(p.get_viewport_rect().size/2)
