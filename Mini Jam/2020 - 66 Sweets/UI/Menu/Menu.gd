extends CanvasLayer

onready var version = $Version
onready var hscore = $Highscore
onready var score = $Score

func _ready():
	Global.scene == "Menu"
	
	Global.load_game()
	Music.play_music("main")
	
	Global.health = 4
	
	Gmotion.touch_mode = 0
	version.text = "Version " + Global.VERSION
	
	hscore.text = "Highscore: " + String(Global.highscore)
	score.text = "Score: " + String(Global.score)
	
	if Global.score <= 0:
		score.visible = false
	else:
		score.visible = true

func _process(delta):
	if Input.is_action_pressed("action"):
		Input.action_release("action")
		Input.action_release("c")
		Global.load_level()
		Sound.play_sound("start")


func _on_Start_Button_button_down():
	Input.action_press("action")
