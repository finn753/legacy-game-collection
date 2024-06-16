extends AudioStreamPlayer

var death = preload("res://Assets/Sounds/Death.wav")
var hit = preload("res://Assets/Sounds/Hit.wav")
var place = preload("res://Assets/Sounds/Place.wav")
var point = preload("res://Assets/Sounds/Point.wav")
var start = preload("res://Assets/Sounds/Start.wav")

func play_sound(s):
	if s == "death":
		if stream != death:
			set_stream(death)
	elif s == "hit":
		if stream != hit:
			set_stream(hit)
	elif s == "place":
		if stream != place:
			set_stream(place)
	elif s == "point":
		if stream != point:
			set_stream(point)
	elif s == "start":
		if stream != start:
			set_stream(start)
	
	play(0)
