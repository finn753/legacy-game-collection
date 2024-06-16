extends CanvasLayer

onready var version = $Version

func _ready():
	Global.scene = "Menu"
	#Global.load_game()
	
	version.text = "Version " + Global.VERSION
	
	Music.play_music("Town")

func _on_Play_button_down():
	Global.join_world()

func _on_Play_mouse_entered():
	Sound.play_sound("Select")


func _on_Delete_button_down():
	pass # Replace with function body.
