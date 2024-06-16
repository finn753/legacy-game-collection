extends CanvasLayer

onready var player = $AnimationPlayer

func play_animation(animation,duration = 1,reverse = false):
	player.playback_speed = 1.0 / duration
	if !reverse:
		player.play(animation)
	elif reverse:
		player.play_backwards(animation)
