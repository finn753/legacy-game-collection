extends CanvasLayer

onready var version = $Version

func _ready():
	version.text = "Version " + Global.VERSION
	Sound.play_music("Factory")

func _on_Button_Play_button_down():
	Global.change_scene("Home")
