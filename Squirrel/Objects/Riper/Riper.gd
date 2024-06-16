extends KinematicBody2D

signal is_ripe
signal is_anim

onready var anim = $AnimationPlayer

export var animate = 8
export var ripe = 9
export var gravity = 100

var velocity = Vector2(0,0)

var is_ripe = false

func _ready():
	Global.connect("time_changed",self,"on_time_changed")

func _physics_process(delta):
	if !is_ripe:
		return
	
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity)

func on_time_changed():
	if Global.time >= ripe:
		anim.play("RESET")
		is_ripe = true
		emit_signal("is_ripe")
	elif Global.time >= animate && !anim.is_playing():
		anim.play("ripe")
		emit_signal("is_anim")
