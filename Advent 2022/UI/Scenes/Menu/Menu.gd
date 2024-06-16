extends CanvasLayer

onready var transition = $Transition
onready var version = $Version

func _ready():
	cheat_update()
	transition.open(1.0,0.25)
	
	version.text = ""
	
	if OS.is_debug_build():
		version.text = "DEBUG "
	
	version.text += Global.VERSION
	Global.overworld_spawn = null

func _on_Play_button_down():
	transition.close(1.0)
	$Load.start(1.0)

func _on_Load_timeout():
	Global.max_coins = 0
	Global.current_coins = 0
	Global.block_switch = true
	var _error = get_tree().change_scene("res://World/World.tscn")

func _on_Yotube_button_down():
	OS.shell_open("https://www.youtube.com/@FinnPickart")

func _on_Discord_button_down():
	OS.shell_open("https://discord.gg/egfTQn862X")

func _on_Cheats_button_down():
	Global.cheat_progress = !Global.cheat_progress
	cheat_update()

func cheat_update():
	$"Cheat Info".visible = Global.cheat_progress
	
	if Global.cheat_progress:
		$Cheats.text = "Cheats: On"
		$"Cheat Info".visible = true
	else:
		$Cheats.text = "Cheats: Off"
		$"Cheat Info".visible = false
