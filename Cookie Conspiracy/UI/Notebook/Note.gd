extends Control

onready var label = $Label
onready var sprite = $Control/Sprite

var text = ""
var animation = ""

func _ready():
	label.text = text
	sprite.animation = animation
