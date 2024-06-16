extends Node2D

export(NodePath) var player_path
export var delay = 1.0

onready var start_pos = position
var start_delay = 0

onready var player = get_node(player_path)
onready var sprite = $AnimatedSprite

var buffer = []
var buff_pos = 0

var mov = Vector2(0,0)

func _ready():
	start_delay = delay
	Global.connect("reset",self,"reset")

func _process(delta):
	buffer.append(player.position)
	
	if delay > 0:
		delay -= delta
		return
	
	var new_pos = buffer[buff_pos]
	mov = new_pos - position
	position = (position + new_pos)/2
	buff_pos += 1
	
	sprite_update()

func reset():
	position = start_pos
	delay = start_delay
	mov = Vector2()
	buff_pos = 0
	buffer = []

func sprite_update():
	if mov.y == 0:
		if mov.x == 0:
			sprite.animation = "idle"
		else:
			sprite.animation = "walk"
	else:
		if mov.y > 0:
			sprite.animation = "fall"
		else:
			sprite.animation = "jump"
	
	if mov.x < 0:
		sprite.flip_h = true
	elif mov.x > 0:
		sprite.flip_h = false

