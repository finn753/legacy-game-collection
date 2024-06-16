extends Node2D

onready var bg_black = $ParallaxBackground/Black

func _ready():
	bg_black.visible = true
	
	Transition.play_animation("FadeOutBlack",5)


func _on_Movement_button_down():
	pass # Replace with function body.
