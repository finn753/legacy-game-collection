extends Camera2D

export var MIN_ZOOM = 1.0
export var MAX_ZOOM = 2.0

func _physics_process(_delta):
	camera_position()
	camera_zoom()

func camera_position():
	var positions = []
	
	for p in get_owner().get_node("Player").get_children():
		if p.control != "ai" && p.is_master:
			positions.push_back(p.position)
	
	if positions == []:
		return
	
	positions.sort_custom(CustomSort,"sort_ascending")
	var sum = positions.front() + positions.back()
	
	if sum/2 < position - Vector2(4,4) || sum/2 > position + Vector2(4,4):
		sum = sum/2 + position
		sum = sum/2 + position
		sum = sum/2 + position
		sum = sum/2 + position
	
	set_position(sum/2)

func camera_zoom():
	var positions = []
	
	for p in get_owner().get_node("Player").get_children():
		if p.control != "ai" && p.is_master:
			positions.push_back(p.position)
	
	if positions == []:
		return
	
	positions.sort_custom(CustomSort,"sort_ascending")
	
	var czoom = positions.front().distance_to(positions.back())/Vector2().distance_to(get_viewport_rect().size)*2.5
	
	if czoom <= MIN_ZOOM:
		czoom = MIN_ZOOM
	elif czoom >= MAX_ZOOM:
		czoom = MAX_ZOOM
	
	if czoom < zoom.x - 0.025 || czoom > zoom.x + 0.025:
		czoom = czoom + zoom.x
		czoom /= 2
		czoom = czoom + zoom.x
		czoom /= 2
		czoom = czoom + zoom.x
		czoom /= 2
		czoom = czoom + zoom.x
		czoom /= 2
	
	set_zoom(Vector2(czoom,czoom))

class CustomSort:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false
