extends Node2D

func _ready():
	Global.scene = "Hide2"

func _on_Retry_button_down():
	Global.death()
