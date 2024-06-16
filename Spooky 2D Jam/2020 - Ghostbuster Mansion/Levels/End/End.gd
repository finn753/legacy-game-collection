extends Node2D

onready var label = $Congrulations

func _ready():
	if Global.progress < 12:
		label.text = "Credits"

func _on_Exit_button_down():
	Global.load_menu()
