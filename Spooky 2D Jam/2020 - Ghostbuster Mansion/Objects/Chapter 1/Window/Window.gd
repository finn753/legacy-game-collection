extends Light2D

onready var area = $Area2D

const MAX_SKIP = 2

var window = true
var clight = false
var cskip = MAX_SKIP

func _physics_process(delta):
	clight = false
	
	if !window:
		if enabled:
			enabled = false
		return
	else:
		if !enabled:
			enabled = true
	
	for p in area.get_overlapping_bodies():
		if p.has_method("get_TYPE"):
			if p.TYPE == "Player" || p.TYPE == "Friend":
				clight = true
	
	if clight == false && Global.player_light == true:
		if cskip > 0:
			clight = true
			cskip -= 1
		else:
			cskip = MAX_SKIP
	Global.player_light = clight
