extends VBoxContainer

onready var b_character = $"Character Button"
onready var s_character = $"Character Button/Sprite"
onready var b_name = $Name
onready var b_control = $"Control Button"

export var id = 0

func _ready():
	update()

func _process(_delta):
	check_despawn()
	if Global.player_data.has(id):
		update()

func update():
	s_character.animation = Global.sprites[Global.player_data[id]["character"]]
	b_control.text = Global.player_data[id]["control"]

func check_despawn():
	if !Global.player_data.has(id):
		queue_free()

func _on_Character_Button_button_down():
	if Global.player_data[id]["character"] + 1 >= Global.sprites.size():
		Global.player_data[id]["character"] = 0
	else:
		Global.player_data[id]["character"] += 1

func _on_Name_text_changed(new_text):
	Global.player_data[id]["name"] = new_text

func _on_Control_Button_button_down():
	if Global.controls.find(Global.player_data[id]["control"]) + 1 >= Global.controls.size():
		Global.player_data[id]["control"] = Global.controls[0]
	else:
		Global.player_data[id]["control"] = Global.controls[Global.controls.find(Global.player_data[id]["control"]) + 1]

func _on_Name_mouse_exited():
	b_name.release_focus()


func _on_Name_focus_entered():
	Motion.ui_stop = true

func _on_Name_focus_exited():
	Motion.ui_stop = false
