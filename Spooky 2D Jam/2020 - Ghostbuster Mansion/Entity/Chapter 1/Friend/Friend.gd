extends Node2D

onready var body = $Body
onready var face = $Face

const TYPE = "Friend"

var occupied = true

const SPEED = 400 * 0.75

func _ready():
	body.playing = true
	face.playing = true
	
#	if Global.progress < 0:
#		if Global.scene == "Floor":
#			Global.progress = 0
#
#	if Global.scene == "Spawn":
#		if Global.progress >= 0:
#			position = Vector2(928,224)
#
#	if Global.scene == "Floor":
#		if Global.progress >= 1:
#			position = Vector2(736,224)

func _physics_process(delta):
	if body == null:
		return
	
	if Global.progress < 5:
		occupied = true
		
		if body.playing == true:
			body.playing = false
		
		if face.animation != "sleep":
			face.animation = "sleep"
	else:
		occupied = false
		
		if body.playing == false:
			body.playing = true
		
		if face.animation != "default":
			face.animation = "default"
	
	calculate_movement()
	
func calculate_movement():
	if body == null:
		return
	
	if occupied:
		return
	
	var player = get_parent().get_node("Player")
	
	body.set_flip_h(player.body.flip_h)
	face.set_flip_h(player.face.flip_h)
	
	var target_pos = player.position
	
	if body.flip_h:
		target_pos = player.position + Vector2(50,0)
	else:
		target_pos = player.position - Vector2(50,0)
	
	
	var angle = Vector2(1,0).angle_to(target_pos-position)
	var cmovement = Vector2(SPEED,0).rotated(angle)
	
	cmovement = Gmotion.limit_speed(cmovement,SPEED)
	position += cmovement

	
func get_TYPE():
	return TYPE
