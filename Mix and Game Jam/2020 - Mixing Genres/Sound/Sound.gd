extends Node

onready var sound = $Sound
onready var music = $Music

var minigame_music = ["Minigame1","Minigame2"]

func play_sound(s):
	var sres = load("res://Sound/" + s + ".wav")
	sound.set_stream(sres)
	sound.play(0)

func play_music(s):
	var mres = load("res://Sound/" + s + ".wav")
	
	if music.get_stream() != mres:
		music.set_stream(mres)
		music.play(0)
	elif !music.playing:
		music.play(0)

func play_random_music():
	randomize()
	play_music(minigame_music[randi()%minigame_music.size()])
