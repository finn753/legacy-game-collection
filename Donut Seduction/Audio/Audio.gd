extends Node

onready var sound = $Sound
onready var sound_enemy = $SoundEnemy

onready var music = $Music

func play_sound(a,random_pitch = false,channel = "sound"):
	var sres = load("res://Audio/Sound/" + a + ".wav")
	
	var c
	if channel == "sound":
		c = sound
	elif channel == "enemy":
		c = sound_enemy
	
	if c.get_stream() != sres:
		c.set_stream(sres)
	if random_pitch:
		c.pitch_scale = (randi()%4+98)/100.0
	c.play(0)

func play_music(a):
	if a == "":
		music.stop()
		return
	
	var sres = load("res://Audio/Music/" + a + ".wav")
	
	if music.playing && music.get_stream() == sres:
		return
	
	if music.get_stream() != sres:
		music.set_stream(sres)
		music.play(0)
	else:
		music.play(0)
