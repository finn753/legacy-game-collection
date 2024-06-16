extends Area2D

onready var trap_animation = $Trap
onready var background = $Background
onready var timer = $Timer
onready var sound = $SoundManager2D

var active = true

func _ready():
	trap_animation.frame = randi()%trap_animation.frames.get_frame_count(trap_animation.animation)
	sound.play_sound("Item_Box")

func _on_Item_Box_body_entered(_body):
	if active:
		sound.volume_db = -80
		active = false
		background.animation = "free"
		timer.start()
		
		if Global.current_trap != Global.traps[trap_animation.frame]:
			Global.current_trap = Global.traps[trap_animation.frame]
		else:
			if trap_animation.frame < Global.traps.size() - 1:
				Global.current_trap = Global.traps[trap_animation.frame + 1]
			else:
				Global.current_trap = Global.traps[0]
		Global.add_score(100)


func _on_Timer_timeout():
	active = true
	visible = active
	background.animation = "spawn"
	sound.volume_db = 0
	#sound.play_sound("Item_Box")


func _on_Background_animation_finished():
	if background.animation == "spawn":
		background.animation = "default"
	elif background.animation == "free":
		visible = false
