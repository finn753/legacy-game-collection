extends AudioStreamPlayer

func play_sound(s):
	var r = load("Sound/" + s + ".wav")
	
	if get_stream() != r:
		set_stream(r)
	
	if !playing:
		play(0)
