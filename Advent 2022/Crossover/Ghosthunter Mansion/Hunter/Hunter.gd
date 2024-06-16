extends Node2D

export var speed = 256

onready var start_pos = position
onready var desinterest = $Desinterest

var on_screen = false

var goal

func _ready():
	Global.connect("reset",self,"reset")

func _process(delta):
	if Global.in_light && on_screen:
		goal = Global.player.position
		desinterest.stop()
	
	if goal != null:
		var vec = position.direction_to(goal)
		
		if position.distance_to(goal) > 16:
			position += vec*speed*delta
		elif position.distance_to(goal) > 2:
			position = (((16)-1)*position + goal)/(16)
		else:
			goal = null
			if desinterest.is_stopped():
				desinterest.start()

func reset():
	goal = start_pos
	position = start_pos

func _on_Desinterest_timeout():
	if goal == null:
		goal = start_pos


func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
