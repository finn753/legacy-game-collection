extends Node

onready var sound = $Sound
onready var music = $Music

func play_sound(a):
	var sres = load("res://Sound/Sound/" + a + ".wav")
	
	if sound.playing && sound.get_stream() == sres:
		return
	
	if sound.get_stream() != sres:
		sound.set_stream(sres)
		sound.play(0)
	else:
		sound.play(0)

func play_music(a):
	var sres = load("res://Sound/Music/" + a + ".wav")
	
	if music.playing && music.get_stream() == sres:
		return
	
	if music.get_stream() != sres:
		music.set_stream(sres)
		music.play(0)
	else:
		music.play(0)
