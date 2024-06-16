extends Node2D

onready var light = $"Screen/Light2D"
onready var audio = $AudioStreamPlayer

onready var chapter1_button = $"Chapter 1"
onready var credits_button = $Credits

onready var version_label = $Version

var select = preload("res://Sounds/Select.wav")

func _ready():
	Music.play_menu()
	version_label.text = "Version " + Global.VERSION

func _process(delta):
	light.position = get_viewport().get_mouse_position()

func _on_Chapter_1_button_down():
	Global.load_room("Spawn")

func _on_Chapter_1_mouse_entered():
	Sound.play_select()
	chapter1_button.rect_scale = Vector2(1.1,1.1)

func _on_Chapter_1_mouse_exited():
	chapter1_button.rect_scale = Vector2(1,1)


func _on_Credits_button_down():
	Global.load_room("End")

func _on_Credits_mouse_entered():
	Sound.play_select()
	credits_button.rect_scale = Vector2(1.1,1.1)


func _on_Credits_mouse_exited():
	credits_button.rect_scale = Vector2(1,1)

