extends Node2D

onready var move = $MovableObject
onready var grid = $MovableObject/GridObject
onready var content = $MovableObject/GridObject/Content
onready var animation = $AnimationPlayer

onready var sprite = content.get_node("AnimatedSprite")
onready var blanket = content.get_node("Blanket")
onready var light = get_node_or_null(light_path)

export(NodePath) var light_path 

var active = false
var player

func _ready():
	grid.set_grid_pos(position)
	position = Vector2(0,0)
	blanket.visible = false
	
	Global.connect("saving",self,"signal_saving")
	Global.connect("saved",self,"signal_saved")

func _on_Area2D_area_entered(a):
	if !active:
		return
	
	var b = a.get_parent().get_parent()
	if b.has_method("is_movable_object") && b.is_walker:
		var p = b.get_parent()
		if p.has_method("is_player"):
			$AutoSave.stop()
			blanket.visible = true
			p.locked_movement = true
			p.sprite.animation = "sleeping"
			player = p
			if light != null:
				light.enabled = false
			Global.sleeping = true
			animation.play("New Day")
			Global.emit_signal("night")
			#Global.new_day()

func collision(step: Vector2, colliding = false, is_walker = false):
	if !colliding && step.y == 0 && is_walker && player == null:
		return false
	return true

func _on_Timer_timeout():
	active = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "New Day":
		#Global.new_day()
		$AutoSave.start()
		Global.sleeping = false
		player.sprite.animation = "default"
		player.handle_motion(Vector2(-1,0),true)
		player.locked_movement = false
		player = null
		if light != null:
			light.enabled = true
		blanket.visible = false
		
		Global.save_game()

func start_new_day():
	Global.new_day()

func sleeping_particle(e):
	player.sleeping_particle.emitting = e

func outside_area():
	Global.emit_signal("clean_outside_area")

func _on_AutoSave_timeout():
	Global.save_game()

func signal_saving():
	$AutoSave.stop()

func signal_saved():
	$AutoSave.start()
