extends Node

var touch_mode = 2

var ui_stop = false

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
	
func get_input_motion(t,p):
	var direction = Vector2(0,0)
	var motion = Vector2(0,0)
	
	if t == null || ui_stop:
		return motion
	
	if Input.is_action_pressed("left_" + t):
		direction.x -= 1
		motion = Vector2(p.SPEED,0)
		
	if Input.is_action_pressed("right_" + t):
		direction.x += 1
		motion = Vector2(p.SPEED,0)
		
	if Input.is_action_pressed("up_" + t):
		direction.y -= 1
		motion = Vector2(p.SPEED,0)
		
	if Input.is_action_pressed("down_" + t):
		direction.y += 1
		motion = Vector2(p.SPEED,0)
	
	if direction == Vector2(0,0):
		motion = Vector2(0,0)
	
	var angle = Vector2(1,0).angle_to(direction)
	return motion.rotated(angle)
	
func get_touch_motion(p):
	var touch_pos = get_viewport().get_mouse_position()
	var angle
	var buffer = Vector2(8,8)
	
	if touch_mode == 0:
		var anchor = p.position * 4
		if touch_pos.x > anchor.x - buffer.x && touch_pos.x < anchor.x + buffer.x && touch_pos.y > anchor.y - buffer.y && touch_pos.y < anchor.y + buffer.y:
			return Vector2()
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - anchor))
	elif touch_mode == 1:
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - Vector2(p.position.x,p.get_viewport_rect().size.y/2)))
	elif touch_mode == 2:
		var anchor = p.get_viewport_rect().size/2
		if touch_pos.x > anchor.x - buffer.x && touch_pos.x < anchor.x + buffer.x && touch_pos.y > anchor.y - buffer.y && touch_pos.y < anchor.y + buffer.y:
			return Vector2()
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - anchor))
		
	return Vector2(p.SPEED,0).rotated(deg2rad(angle))
	
#Vector2(p.get_viewport_rect().size/2)

func get_target_motion(p,t):
	var motion = Vector2(0,0)
	var buffer = Vector2(4,4)
	
	if t == null:
		return motion
	
	if p.position >= t-buffer && p.position <= t+buffer:
		return motion
	
	motion = Vector2(p.SPEED,0)
	motion = motion.rotated(Vector2(1,0).angle_to(t-p.position))
	
	return motion

func release():
	Input.action_release("up")
	Input.action_release("down")
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("Overview")
	Input.action_release("hint")
