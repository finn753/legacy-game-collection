extends CanvasLayer

onready var version_label = $Version

func _ready():
	version_label.text = "Version " + Global.VERSION
	
	Global.collected_memories = []
	Global.banned_memories = []
	
	Transition.play_animation("FadeOutBlack",2)
	Sound.play_music("Void")

func _on_Button_button_down():
	Sound.play_sound("UI_Click")
	OS.shell_open("https://finn378.itch.io/")

func _on_Play_button_down():
	Sound.play_sound("UI_Click")
	get_tree().change_scene("res://World/World.tscn")


func _on_button_mouse_entered():
	Sound.play_sound("UI_Select")
