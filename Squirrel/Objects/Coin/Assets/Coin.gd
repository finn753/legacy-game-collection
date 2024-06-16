extends Area2D

onready var audio = $AudioStreamPlayer

export var has_to_ripe = false

var collected = false
var available = true

func _ready():
	Global.init_coin()
	
	if has_to_ripe:
		available = false
		$AnimatedSprite.play("unripe")
		if get_parent().has_signal("is_ripe"):
			get_parent().connect("is_ripe",self,"on_is_ripe")
			get_parent().connect("is_anim",self,"on_is_anim")
	
	if available:
		$AnimationPlayer.play("Hover")

func collect():
	if collected || !available:
		return
	collected = true
	
	if Global.max_coins != 1:
		audio.pitch_scale = (float(Global.current_coins) / (Global.max_coins - 1)) + 1
	print(audio.pitch_scale)
	Global.collect_coin()
	audio.play(0)
	visible = false

func make_available():
	available = true
	$AnimationPlayer.play("Hover")
	$AnimatedSprite.play("ripe")

func on_is_ripe():
	make_available()

func on_is_anim():
	$AnimatedSprite.play("ripe")

func _on_Coin_body_entered(body):
	if body.has_method("is_player"):
		collect()

func _on_AudioStreamPlayer_finished():
	queue_free()
