extends AudioStreamPlayer

var hit = preload("res://Sounds/Hit.wav")
var point = preload("res://Sounds/Point.wav")
var select = preload("res://Sounds/Select.wav")
var beep_h = preload("res://Sounds/BeepH.wav")
var beep_l = preload("res://Sounds/BeepL.wav")

func play_hit():
	set_stream(hit)
	play()

func play_point():
	set_stream(point)
	play()
	
func play_select():
	set_stream(select)
	play()
	
func play_beep_h():
	set_stream(beep_h)
	play()
	
func play_beeep_l():
	set_stream(beep_l)
	play()
