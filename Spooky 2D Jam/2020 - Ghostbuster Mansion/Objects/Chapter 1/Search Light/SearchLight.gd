extends Light2D

onready var area = $Area2D

onready var lstart = $Start
onready var lend = $End
onready var lspeed = $Speed

const MAX_SKIP = 2

var clight = false
var cskip = MAX_SKIP

var direction = 0 #0 = Start -> End 1 = End -> Start

func _physics_process(delta):
	move()
	
	clight = false
	
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

func move():
	var cstart = lstart.text.split(",")
	var cend = lend.text.split(",")
	
	var start = Vector2(int(cstart[0]),int(cstart[1]))
	var end = Vector2(int(cend[0]),int(cend[1]))
	var speed = int(lspeed.text)
	
#	if direction == 1 && start - Vector2(speed/2,speed/2) <= position && start + Vector2(speed/2,speed/2) >= position:
#		#position = start
#		direction = 0
#	elif direction == 0 && end - Vector2(speed/2,speed/2) <= position && end + Vector2(speed/2,speed/2) >= position:
#		#position = end
#		direction = 1
	
	if direction == 1 && start > position:
		direction = 0
		position = start
	elif direction == 0 && end < position:
		direction = 1
		position = end
	
	var movement = Vector2()
	
	if direction == 0:
		var angle = Vector2(1,0).angle_to(end-position)
		movement = Vector2(speed,0).rotated(angle)
	elif direction == 1:
		var angle = Vector2(1,0).angle_to(start-position)
		movement = Vector2(speed,0).rotated(angle)
	
	position += movement
