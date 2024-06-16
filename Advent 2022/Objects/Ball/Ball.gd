extends KinematicBody2D

onready var col = $CollisionShape2D
onready var col2 = $CollisionShape2D2
onready var sprite = $CollisionShape2D/Sprite
onready var area = $CollisionShape2D/Area2D

onready var start_pos = position

export var max_size = 3

var speed = 75
var gravity = 500

var size = 1

const MAX_STEPS = 30
var steps = 0
var velocity = Vector2()
var overlapping = false
var chain_size = 0

func _ready():
	Global.connect("reset",self,"reset")

func _physics_process(delta):
	check_overlap()
	
	if size != col.scale.x:
		col.set_deferred("scale",Vector2(size,size))
		col2.set_deferred("scale",Vector2(size,size))
		col2.set_deferred("position",Vector2(0,-2)*size)
	
	#velocity.x *= 5/6
	velocity.y += gravity * size * delta
	
	if round(steps) != 0:
		velocity.x = (speed/size) * (steps/MAX_STEPS)
		steps -= sign(steps) * delta * 60
		steps = round(steps)
		
		if abs(steps) == 1:
			steps = 0
	
	velocity = move_and_slide(velocity,Vector2(0,-1))
	velocity = velocity.clamped(speed*2)
	
	grow(velocity.x, delta)
	
	if velocity.y == 0:
		velocity.x = 0

func check_overlap():
	overlapping = false
	
	for b in area.get_overlapping_bodies():
		if b.has_method("is_player"):
			on_collision(b.position)
			continue
		
		if !b.has_method("is_snowball"):
			continue
		
		if b == self:
			continue
		
		overlapping = true
		
		if b.size < size:
			continue
		
		#print("Ball")
		
		on_collision(b.position, true, false)

func on_collision(pos, force = false, player = true):
	var vec = pos - position
	
	#print(vec)
	
	if vec.y < -2 * size && !force:
		#print("Lap" + str(overlapping))
		
		if !(overlapping && player):
			return
	
	steps = -MAX_STEPS * sign(vec.x)
	
	if overlapping && player:
		steps *= 1.5

func grow(v, delta = 1/60):
	var s = sign(v)
	v = abs(v)
	
	if v < 4:
		return
	
	size += 0.25*(delta/size)
	sprite.rotation_degrees += 2*(v/speed)*(delta)*s*60
	
	if size > max_size:
		size = max_size

func reset():
	position = start_pos
	size = 1

func is_snowball():
	return true
