extends KinematicBody2D

onready var collision_shape = $CollisionShape2D
onready var tween = $Tween
onready var camera = $Camera2D
onready var sprite = $AnimatedSprite

export var move_speed = 175

var velocity := Vector2.ZERO

export var jump_height = 50.0
export var jump_time_to_peak = 0.35
export var jump_time_to_descent = 0.3
export var extra_jump_count = 1

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

onready var s_zoom = $Camera2D.zoom

var snap_normal = Vector2.DOWN

var buffer_jump = false
var on_ground = false
var extra_jumps_left = extra_jump_count

var riding
var has_rider = false

func _ready():
	camera.zoom *= 2
	
	tween.remove_all()
	tween.interpolate_property(camera,"zoom",null,s_zoom,0.75,Tween.TRANS_BACK,Tween.EASE_OUT)
	tween.start()

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if is_on_floor():
		on_ground = true
		extra_jumps_left = extra_jump_count
		Time.change_factor("jump",0)
		Time.change_factor("smash",0)
		
		if riding == null:
			Time.change_factor("boost",0)
	else:
		if $Coyote.is_stopped() && on_ground == true:
			$Coyote.start()
	
	if on_ground || riding != null:
		if Input.is_action_just_pressed("jump") || buffer_jump:
			buffer_jump = false
			jump()
	else:
		if Input.is_action_just_pressed("jump"):
			if extra_jumps_left >= 1:
				buffer_jump = false
				jump()
			else:
				buffer_jump = true
				$BufferJump.start()
	
	var snap_modify = 0
	if velocity.y >= 0:
		snap_modify = 8
	
	if velocity.x != 0:
		Time.change_factor("_move",0.25)
	else:
		Time.change_factor("_move",0)
	
	if riding != null:
		position = riding.rider_pos
	else:
		#velocity = move_and_slide_with_snap(velocity, snap_normal * snap_modify, Vector2.UP, false, 4, PI/4, false)
		velocity = move_and_slide_with_snap(velocity, snap_normal * snap_modify, Vector2.UP)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.has_method("kick"):
			collision.collider.kick(-collision.normal * 100)

func get_gravity() -> float:
	if Input.is_action_pressed("down"):
		if !is_on_floor():
			Time.change_factor("smash",1)
		return fall_gravity * 2
	
	if velocity.y < 0.0:
		var modifier = 0
		
		if Input.is_action_pressed("jump"):
			modifier = -velocity.y
		
		return jump_gravity - modifier
	else:
		return fall_gravity

func jump(free = false):
	if riding != null:
		riding.unsaddle()
		riding = null
	collision_shape.set_deferred("disabled",false)
	
	Time.change_factor("jump",0.25)
	Time.change_factor("llama_move",0)
	Time.change_factor("llama_jump",0)
	$AudioStreamPlayer.play(0)
	velocity.y = jump_velocity
	
	if !free && !on_ground:
		Time.change_factor("jump",0.5)
		extra_jumps_left -= 1
	
	on_ground = false
	
	if extra_jumps_left < 0:
		extra_jumps_left = 0

func get_input_velocity():
	var horizontal = 0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1
	if Input.is_action_pressed("right"):
		horizontal += 1
	
	if horizontal < 0:
		sprite.flip_h = true
	elif horizontal > 0:
		sprite.flip_h = false
	
	if riding != null:
		riding.direction = horizontal
		return 0
	
	return horizontal

func set_boost(act):
	if act:
		if velocity.y < 0:
			#velocity.y *= 2
			velocity.y += jump_velocity
			extra_jumps_left = extra_jump_count
			Time.change_factor("boost",Time.factors["boost"] + 1)

func _on_Buffer_Jump_timeout():
	buffer_jump = false

func _on_Coyote_timeout():
	on_ground = is_on_floor()

func death():
	Global.restart_game()

func teleport(to: Vector2):
	set_position(to)

func is_player():
	return true
