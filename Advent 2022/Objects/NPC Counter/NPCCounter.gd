extends Area2D

func _process(delta):
	var sum = 0
	
	for b in get_overlapping_bodies():
		if !b.has_method("is_npc"):
			return
		
		sum += 1
		b.no_chase = true
		b.jump_velocity = 0
	
	if sum != Global.current_coins:
		$AudioStreamPlayer.play()
		Global.current_coins = sum
