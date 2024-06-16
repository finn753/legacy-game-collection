extends RigidBody2D

export(String,"Cookie","Computer","Mom","Lady","Old Lady","Old Man","Mother","Father","Strange Man") var character = "Mom"
export var min_progress = 0
export var max_progress = -1
export(String, MULTILINE) var text = ""
export var evidence = ""
export var flip_direction = false
export var fixed_direction = false

onready var sprite = $AnimatedSprite
onready var label = $Speech/Text
onready var btn_node = $"Speech/Button Note"
onready var area = $Area2D
const TYPE = "NPC"

func _ready():
	sprite.animation = character
	sprite.flip_h = flip_direction
	label.visible = false
	btn_node.visible = false
	label.text = text
	
	if Global.progress >= min_progress && (Global.progress <= max_progress || max_progress < 0):
		pass
	else:
		queue_free()
	
	for gn in Global.notes:
		if gn[0] == text && gn[1] == sprite.animation:
			btn_node.queue_free()

func _process(delta):
	if label.visible:
		for p in area.get_overlapping_bodies():
			if p.has_method("get_type"):
				if p.get_type() == "Player":
					if !fixed_direction:
						if p.position.x < position.x:
							sprite.flip_h = true
						elif p.position.x > position.x:
							sprite.flip_h = false

func _on_Area2D_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			label.visible = true
			
			if has_node("Speech/Button Note"):
				for gn in Global.notes:
					if gn[0] == text && gn[1] == sprite.animation:
						btn_node.queue_free()
			
			if has_node("Speech/Button Note"):
				btn_node.visible = true


func _on_Area2D_body_exited(body):
	if body.has_method("get_type"):
		if body.get_type() == "Player":
			label.visible = false
			if has_node("Speech/Button Note"):
				btn_node.visible = false


func _on_Button_Note_button_down():
	if has_node("Speech/Button Note"):
		if Global.notes == []:
			UI.new_notifications.push_back("You've wrote your first note. Press E to open your notebook")
		Global.notes.push_back([text,sprite.animation,evidence])
		btn_node.queue_free()
		Sound.play_sound("Note")
