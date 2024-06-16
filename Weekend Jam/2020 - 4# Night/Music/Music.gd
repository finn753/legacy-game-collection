extends AudioStreamPlayer

func play_music(m):
	var r = load("Music/" + m + ".wav")
	
	if get_stream() != r:
		set_stream(r)
	
	if !playing:
		play(0)
