extends Area2D

onready var cooldown = $Cooldown

var active = true

func _process(delta):
	visible = active

func _on_BoostGem_body_entered(body):
	if !active:
		if cooldown.is_stopped():
			cooldown.start()
		return
	
	if body.has_method("boost"):
		cooldown.start()
		active = !body.boost()

func _on_Cooldown_timeout():
	active = true
