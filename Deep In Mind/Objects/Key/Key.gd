extends RigidBody2D

export var key = ""

var TYPE = "Key" + key

func _ready():
	TYPE = "Key"+ key

func get_type():
	return TYPE
