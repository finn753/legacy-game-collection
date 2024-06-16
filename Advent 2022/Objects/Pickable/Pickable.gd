extends Area2D

var pickable = true
var holder

func _on_Pickable_body_entered(body):
	if body.has_method("is_player"):
		if body.holding == null && pickable:
			body.holding = self
			holder = body
			pickable = false

func _on_Pickable_area_entered(area):
	if area.has_method("is_placeholder"):
		if area.holding == null:
			area.set_holding(self)
			holder.holding = null
