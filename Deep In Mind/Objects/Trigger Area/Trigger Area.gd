extends Area2D

export(String,"Entered","Exited") var mode = "Entered"

export var trigger = ""

export var memory = ""
export var forget = ""
export var ban = ""
export var unban = ""


func _on_Trigger_Area_body_entered(body):
	if trigger != "" && mode == "Entered":
		if body.has_method("get_type"):
			if body.get_type() == trigger:
				Global.add_memory(memory)
				Global.remove_memory(forget)
				Global.ban_memory(ban)
				Global.unban_memory(unban)

func _on_Trigger_Area_body_exited(body):
	if trigger != "" && mode == "Exited":
		if body.has_method("get_type"):
			if body.get_type() == trigger:
				Global.add_memory(memory)
				Global.remove_memory(forget)
				Global.ban_memory(ban)
				Global.unban_memory(unban)
