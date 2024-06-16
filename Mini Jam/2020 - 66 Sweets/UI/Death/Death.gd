extends CanvasLayer

onready var score = $Control/Score
onready var hscore = $Control/Highscore

func _ready():
	Sound.play_sound("death")
	Global.save_game()
	
	score.text = "Score: " + String(Global.score)
	hscore.text = "Highscore: " + String(Global.highscore)

func _on_Timer_timeout():
	Global.load_menu()
