extends Node

var touch_mode = 2
var buffer = Vector2(32,32)

var in_window = false

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
	
func get_touch_motion(p):
	if !in_window:
		return Vector2()
	
	var touch_pos = get_viewport().get_mouse_position()
	var angle
	
	if touch_mode == 0:
		var anchor = p.position
		if touch_pos.x > anchor.x - buffer.x && touch_pos.x < anchor.x + buffer.x && touch_pos.y > anchor.y - buffer.y && touch_pos.y < anchor.y + buffer.y:
			return Vector2()
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - anchor))
	elif touch_mode == 1:
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - Vector2(p.position.x,p.get_viewport_rect().size.y/2)))
	else:
		var anchor = p.get_viewport_rect().size/2
		if touch_pos.x > anchor.x - buffer.x && touch_pos.x < anchor.x + buffer.x && touch_pos.y > anchor.y - buffer.y && touch_pos.y < anchor.y + buffer.y:
			return Vector2()
		angle = rad2deg(Vector2(1,0).angle_to(touch_pos - anchor))
	
	var direction = Vector2(1,0).rotated(deg2rad(angle))
	p.direction = Vector2(round(direction.x),round(direction.y))
	
	return Vector2(p.speed,0).rotated(deg2rad(angle))
	
#Vector2(p.get_viewport_rect().size/2)

func _notification(n):
	match n:
		NOTIFICATION_WM_MOUSE_EXIT:
			in_window = false
		NOTIFICATION_WM_MOUSE_ENTER:
			in_window = true
