extends AudioStreamPlayer2D

var spath = "res://Audio/Sound/"
var df = ".wav"

func play_sound(s):
	var sres = load(spath + s + df)
	
	if playing && get_stream() == sres:
		return
	
	if get_stream() != sres:
		set_stream(sres)
		play(0)
	else:
		play(0)
