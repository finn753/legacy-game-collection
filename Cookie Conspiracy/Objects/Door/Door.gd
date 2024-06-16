extends Area2D

export var id = 0
export var scene = "Town"
export var key = ""
export(String,"key","code") var key_mode = "key"
export var locked_notification = true
export var door_visible = true
export(String,"","factory") var type = ""

onready var sprite = $AnimatedSprite
onready var hint = $Hint

const TYPE = "Door"

var open = false
var body_in = false

func _ready():
	sprite.animation = type + "closed"
	hint.visible = false
	sprite.visible = door_visible

func _process(delta):
	if open:
		if Input.is_action_just_pressed("action"):
			Motion.door = id
			Global.change_scene(scene)
	elif body_in:
		if key_mode == "code":
			var ckeys = []
			for nc in Global.notes.size():
				ckeys.push_back(Global.notes[nc][0])
			if key == "" || key in ckeys:
				open = true
				sprite.animation = type + "open"
				hint.visible = true

func _on_Door_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			body_in = true
			if key_mode == "key":
				if key == "" || key in Global.keys:
					open = true
					sprite.animation = type + "open"
					hint.visible = true
				elif locked_notification:
					UI.new_notifications.push_back("This door is locked")
			elif key_mode == "code":
				var ckeys = []
				for nc in Global.notes.size():
					ckeys.push_back(Global.notes[nc][0])
				for ck in ckeys:
					if key == "" || key in ck:
						open = true
						sprite.animation = type + "open"
						hint.visible = true
						break
				open = true
				for cs in key.length():
					cs = key[cs-1]
					print(str(cs))
					if cs in ckeys:
						pass
					else:
						open = false
				if open:
					sprite.animation = type + "open"
					hint.visible = true
				elif !open && locked_notification:
					UI.new_notifications.push_back("""You need a code for this door.
					Write the right code in your notebook and you can open this door""")

func _on_Door_body_exited(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			body_in = false
			open = false
			sprite.animation = type + "closed"
			hint.visible = false

func get_type():
	return TYPE
