extends Area2D

export var key = ""

onready var hint = $Hint

func _ready():
	hint.visible = false
	if key in Global.keys:
		queue_free()

func _process(delta):
	if hint.visible:
		if Input.is_action_just_pressed("action"):
			Global.keys.push_back(key)
			UI.new_notifications.push_back("""You've found a key.
			I wonder wich door it can unlock""")
			queue_free()

func _on_Key_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			hint.visible = true

func _on_Key_body_exited(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			hint.visible = false
