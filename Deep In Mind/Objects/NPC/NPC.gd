extends RigidBody2D

export(String,"Boy") var role = "Boy"

onready var sprite = $AnimatedSprite

func _ready():
	sprite.animation = role
