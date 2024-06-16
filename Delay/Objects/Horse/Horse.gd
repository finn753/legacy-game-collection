extends KinematicBody2D

export var can_jump = true

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D
onready var anim = $AnimationPlayer

var velocity = Vector2(0,0)

export var jump_height = 100.0
export var jump_time_to_peak = 0.5
export var jump_time_to_descent = 0.4

onready var rider_pos = position + $RiderPos.position
onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var direction = 0
var speed = 200

var ridable = true
var has_rider = false
var riding
var rider

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = direction * speed
	
#	if !is_on_floor() || riding != null:
#		if anim.current_animation != "Air":
#			anim.play("Air")
#	elif direction != 0:
#		if anim.current_animation != "Walk":
#			anim.play("Walk")
#	else:
#		if anim.current_animation != "Idle":
#			anim.play("Idle")
	
	if riding != null:
		if has_rider:
			Time.change_factor("llama_stack",1)
		riding.direction = direction
		rider_pos = position + $RiderPos.position
		
	if velocity.x < 0:
		sprite.scale.x = -1
	elif velocity.x > 0:
		sprite.scale.x = 1
		
	if has_rider && riding == null:
		if velocity.x != 0:
			Time.change_factor("llama_move",0.5)
		else:
			Time.change_factor("llama_move",0)
		
		if is_on_floor():
			Time.change_factor("llama_jump",0)
			Time.change_factor("boost",0)
		
		if is_on_wall() && is_on_floor():
			jump()
	
	if riding != null:
		position = riding.rider_pos
	else:
		var snap_modify = 0
		if velocity.y >= 0:
			snap_modify = 8
		
		#velocity = move_and_slide_with_snap(velocity, Vector2.DOWN * snap_modify, Vector2.UP, false, 4, PI/4, false)
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN * snap_modify, Vector2.UP)
		
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.has_method("kick"):
			collision.collider.kick(-collision.normal * 100)
	
	rider_pos = position + $RiderPos.position

func set_boost(act):
	if act:
		if velocity.y < 0:
			#velocity.y *= 2
			velocity.y += jump_velocity
			Time.change_factor("boost",Time.factors["boost"] + 1)

func get_gravity() -> float:
	if velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity

func jump():
	velocity.y = jump_velocity
	Time.change_factor("llama_jump",0.5)
	$AudioStreamPlayer.play()

func _on_Saddle_body_entered(body):
	if body == self:
		return
	
	if (body.has_method("is_player") || body.has_method("is_llama")) && ridable:
		if body.has_method("is_llama"):
			if !body.has_rider:
				return
			elif body.rider.has_rider:
				return
		body.riding = self
		rider = body
		body.collision_shape.set_deferred("disabled",true)
		has_rider = true

func unsaddle():
	$AnimationPlayer.play("Idle")
	Time.change_factor("llama_stack",0)
	direction = 0
	ridable = false
	rider = null
	has_rider = false
	
	if riding != null:
		riding.unsaddle()
		riding = null
	
	collision_shape.set_deferred("disabled",false)
	
	$Pause.start()

func _on_Pause_timeout():
	ridable = true

func is_llama():
	return true

func _on_Jump_timeout():
	jump()
