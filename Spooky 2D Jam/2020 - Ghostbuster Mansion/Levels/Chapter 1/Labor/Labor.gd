extends Node2D

onready var ylight = $"Button/ButtonG/Light2D"
onready var rlight = $"Button/ButtonR/Light2D"
onready var blight = $"Button/ButtonB/Light2D"

var solution = "rby"
var code = ""

func _on_ButtonG_body_entered(body):
	if !"y" in code:
		code = code + "y"
		if code.length() != 3: Sound.play_beep_h()
		ylight.enabled = true
	check()

func _on_ButtonR_body_entered(body):
	if !"r" in code:
		code = code + "r"
		if code.length() != 3: Sound.play_beep_h()
		rlight.enabled = true
	check()

func _on_ButtonB_body_entered(body):
	if !"b" in code:
		code = code + "b"
		if code.length() != 3: Sound.play_beep_h()
		blight.enabled = true
	check()

func check():
	if code.length() == 3:
		if code == solution:
			if Global.progress <= 4:
				Sound.play_point()
				Global.progress = 5
		else:
			blight.enabled = false
			rlight.enabled = false
			ylight.enabled = false
			code = ""
			Sound.play_beeep_l()
