extends StaticBody2D

onready var sprite = $Sprite

func _ready():
	sprite.rect_scale.y = 1/scale.y
	sprite.rect_size.y = 16 * scale.y
