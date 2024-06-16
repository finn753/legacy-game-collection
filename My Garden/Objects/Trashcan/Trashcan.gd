extends Area2D

func _on_Trashcan_area_entered(a):
	if a.get_parent().has_method("get_type"):
		if a.get_parent().get_type() == "Plant":
			a.get_parent().queue_free()
