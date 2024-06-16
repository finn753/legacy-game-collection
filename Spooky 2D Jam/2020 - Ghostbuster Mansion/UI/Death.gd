extends CanvasLayer

onready var label = $Label

func _ready():
	label.text = "TRY " + String(Global.deaths + 1)
	
	if Global.scene == "Encounter" && Global.progress == 2:
		Global.progress = 1
		
	Sound.play_hit()

func _on_Timer_timeout():
	print("d: " + Global.scene)
	Global.player_light = false
	Global.load_room(Global.scene)
