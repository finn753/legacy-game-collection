extends Area2D

var holding

func _process(delta):
	if holding != null:
		holding.position = position

func set_holding(h):
	if holding == null:
		Global.current_coins += 1
	
	holding = h
	
	if h != null:
		$AudioStreamPlayer.play()

func is_placeholder():
	return true
