extends Control

onready var apple = $Apple
onready var banana = $Banana
onready var strawberry = $Strawberry

func _process(delta):
	visible = !Global.ability.has("double_jump") && !Global.inventory.empty()
	
	apple.self_modulate = Color(0,0,0)
	banana.self_modulate = Color(0,0,0)
	strawberry.self_modulate = Color(0,0,0)
	
	if Global.inventory.has("apple"):
		apple.self_modulate = Color(1,1,1)
	
	if Global.inventory.has("banana"):
		banana.self_modulate = Color(1,1,1)
	
	if Global.inventory.has("strawberry"):
		strawberry.self_modulate = Color(1,1,1)
