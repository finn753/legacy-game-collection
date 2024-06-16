extends ColorRect

var screen_size = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	_on_TPParticle_mouse_entered()

func _on_TPParticle_mouse_entered():
	rect_position.x = randi()%int(screen_size.x)
	rect_position.y = randi()%int(screen_size.y)
