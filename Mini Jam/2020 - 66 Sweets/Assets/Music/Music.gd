extends AudioStreamPlayer

var main = preload("res://Assets/Music/Main.wav")

func play_music(m):
	if m == "main":
		if stream != main:
			set_stream(main)
	
	if !playing:
		play(0)
