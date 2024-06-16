extends Area2D

export var dest = 0
export var exit = false

var buffer = 0
var inside = null
var on_screen = false

var locked = false

func _ready():
	if exit:
		visible = false
		Global.connect("coin_collected",self,"check_exit")
		check_exit()
	
	$JumpPrompt.visible = false
	
	if Global.day < dest || dest > Global.playable_days || Global.month != 12:
		locked = true
	
	sprite_update()

func _unhandled_input(_event):
	if locked || inside == null || (exit && !visible):
		return
	
	if Input.is_action_just_pressed("interact"):
		teleport_body(inside)
		inside = null
		$JumpPrompt.visible = false

func _on_TeleporterArea_body_entered(body):
	if locked || (exit && !visible):
		return
	
	if buffer > 0:
		buffer -= 1
		return
	
	if dest == null:
		printerr("Error: No destination selected")
		return
	
	if body.has_method("is_player"):
		inside = body
		$JumpPrompt.visible = true

func teleport_body(body):
	if Global.current_level == 0:
		Global.overworld_spawn = position + get_parent().position
	
	Global.change_level(dest)

func sprite_update():
	if locked:
		$ColorRect.color = Color(82.0/255,51.0/255,63.0/255)

func check_exit():
	if on_screen && Global.max_coins == Global.current_coins:
		visible = true

func _on_TeleporterArea_body_exited(body):
	if body == inside:
		inside = null
		$JumpPrompt.visible = false

func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
