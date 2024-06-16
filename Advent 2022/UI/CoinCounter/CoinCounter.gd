extends Label

export var backwards = false
export var no_text = false

var completed = false

func _ready():
	if no_text:
		$Sprite.visible = false
	
	update_text()

func _process(_delta):
	update_text()

func update_text():
	if no_text:
		text = ""
	elif backwards:
		text = str(Global.max_coins - Global.current_coins)
	else:
		text = str(Global.current_coins) + " ] " + str(Global.max_coins)
	
	if Global.current_coins == Global.max_coins && Global.max_coins > 0:
		if completed:
			return
		
		Global.save_game()
		completed = true
		$CPUParticles2D.emitting = true
		$AudioStreamPlayer.play(0)
		#Global.text_box = "Congrulations"
