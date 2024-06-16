extends CanvasLayer

onready var version = $Version

func _ready():
	Global.scene = "End"
	#Global.save_game()
	
	version.text = "Version " + Global.VERSION

func _on_Play_button_down():
	Global.join_menu()

func _on_Menu_mouse_entered():
	Sound.play_sound("Select")
