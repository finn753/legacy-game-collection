extends StaticBody2D

onready var sprite = $Sprite

func _ready():
	sprite.scale.x = 1/abs(scale.x)
	sprite.position.x = -(48-abs(scale.x)*16)/(2*abs(scale.x))
	sprite.region_rect = Rect2(48-abs(scale.x)*16,0,abs(scale.x)*16,9)
