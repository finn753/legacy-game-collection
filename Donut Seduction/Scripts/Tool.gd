extends Node

func is_in_area(o,a,b):
	if o >= a && o <= b:
		return true
	return false
	
func is_in_area_vector(o: Vector2,a: Vector2,b: Vector2):
	if is_in_area(o.x,a.x,b.x) && is_in_area(o.y,a.y,b.y):
		return true
	return false
