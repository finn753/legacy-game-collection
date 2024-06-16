extends Area2D

export var minigame = ""


func _on_MinigameArea_area_entered(area):
	if area.get_parent().has_method("is_player"):
		Global.minigame = minigame
		Time.change_factor("minigame",1)

func _on_MinigameArea_area_exited(area):
	if area.get_parent().has_method("is_player"):
		Global.minigame = ""
		Time.change_factor("minigame",0)
