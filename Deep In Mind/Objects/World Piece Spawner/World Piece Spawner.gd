extends Node2D

export var memory = ""
export var mirror = false

onready var animation = $AnimationPlayer

var children = []

func _ready():
	for c in get_children():
		if c is AnimationPlayer:
			pass
		else:
			children.push_back(c.duplicate())
			c.queue_free()

func _process(delta):
	if mirror == false:
		if Global.has_memory(memory) && !Global.has_ban(memory):
			if get_child_count() != children.size() + 1:
				visible = false
				for c in children:
					add_child(c.duplicate())
				Sound.play_sound("Spawn_Memory")
				animation.play("FadeIn")
		else:
			if get_child_count() != 1:
				animation.play("FadeOut")
	else:
		if Global.has_memory(memory) && !Global.has_ban(memory):
			if get_child_count() != 1:
				animation.play("FadeOut")
		else:
			if get_child_count() != children.size() + 1:
				visible = false
				for c in children:
					add_child(c.duplicate())
				Sound.play_sound("Spawn_Memory")
				animation.play("FadeIn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		for c in get_children():
			if c is AnimationPlayer:
				pass
			else:
				c.queue_free()
