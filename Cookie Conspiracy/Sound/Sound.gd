extends Node

onready var music = $Music
onready var sound = $Sound

func play_sound(s):
	var sres = load("res://Sound/Sound/" + s + ".wav")
	if sound.get_stream() != sres:
		sound.set_stream(sres)
		sound.play(0)
	else:
		sound.play(0)

func play_music(m):
	var mres = load("res://Sound/Music/" + m + ".wav")
	if music.get_stream() != mres:
		music.set_stream(mres)
		music.play(0)
	elif !music.playing:
		music.play(0)
