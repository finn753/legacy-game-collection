extends Area2D

export var szene = ""
export var path = "res://World/"

onready var sprite = $AnimatedSprite
onready var animation = $AnimationPlayer

func _on_Door_body_entered(body):
	if body.has_method("get_type") && body.get_type() == "Player":
		if szene == "House":
			Global.save_game()
		
		animation.play("FadeInBlack")


func _on_Open_body_entered(body):
	if body.has_method("get_type") && body.get_type() == "Player":
		sprite.animation = "open"


func _on_Open_body_exited(body):
	if body.has_method("get_type") && body.get_type() == "Player":
		sprite.animation = "close"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeInBlack":
		var err = get_tree().change_scene(path + szene + "/" + szene + ".tscn")
		if err == 0:
			err = 0
