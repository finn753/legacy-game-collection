extends AudioStreamPlayer

var spath = "res://Audio/Sound/"
var df = ".wav"

func play_sound(s,random_pitch = false):
	var sres = load(spath + s + df)
	
	if playing && get_stream() == sres:
		return
	
	if random_pitch:
		pitch_scale = (randi()%4+98)/100.0
	
	if get_stream() != sres:
		set_stream(sres)
		play(0)
	else:
		play(0)
