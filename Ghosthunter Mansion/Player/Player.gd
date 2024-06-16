extends KinematicBody2D

export var speed = 75

onready var body = $Body

var mov_dir = Vector2(0,0)
var velocity = Vector2(0,0)

func _ready():
	Global.player = self

func _process(delta):
	get_input()
	update_sprite()

func _physics_process(delta):
	var n_vel = mov_dir*speed
	velocity = (7*velocity + n_vel)/8
	
	if velocity.round() == n_vel.round():
		velocity = n_vel
	
	velocity = move_and_slide(velocity)

func get_input():
	mov_dir = Input.get_vector("left","right","up","down")

func update_sprite():
	if mov_dir.x < 0:
		body.scale.x = -abs(body.scale.x)
	elif mov_dir.x > 0:
		body.scale.x = abs(body.scale.x)
	
	$Label.text = str(Global.in_light)

func is_player():
	return true
