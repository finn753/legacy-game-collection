extends Area2D

export var memory = ""
export var forget = ""
export var ban = ""
export var unban = ""

var collectable = false

func _process(delta):
	if Global.has_ban(memory):
		collectable = false
	elif Global.has_memory(memory):
		collectable = false
	else:
		collectable = true
	
	visible = collectable

func _on_Memory_Book_body_entered(body):
	if collectable:
		if body.has_method("get_type"):
			if body.get_type() == "Player":
				Sound.play_sound("Collect_Memory")
				Global.add_memory(memory)
				Global.remove_memory(forget)
				Global.ban_memory(ban)
				Global.unban_memory(unban)
