extends Node2D

onready var container = $ScrollContainer/VBoxContainer

onready var note_res = preload("res://UI/Notebook/Note.tscn")

onready var line_edit = $LineEdit

func open():
#	#Clear Container
#	for n in container.get_children():
#		n.queue_free()
#
#	for n in Global.notes:
#		var new_note = note_res.instance()
#		print(str(n))
#		new_note.text = n[0]
#		new_note.animation = n[1]
#		container.add_child(new_note)
#
	add_new_notes()
	visible = true

func _process(delta):
	if visible:
		add_new_notes()

func add_new_notes():
	for gn in Global.notes:
		var cadded = false
		
		for an in container.get_children():
			if an.text == gn[0] && an.animation == gn[1]:
				cadded = true
				break
		
		if !cadded:
			var new_note = note_res.instance()
			new_note.text = gn[0]
			new_note.animation = gn[1]
			container.add_child(new_note)


func _on_Button_Send_button_down():
	if line_edit.text.strip_edges() != "":
		Global.notes.push_back([line_edit.text.strip_edges(),"None"])
		line_edit.release_focus()
		Sound.play_sound("Note")
	line_edit.text = ""
	


func _on_LineEdit_mouse_exited():
	line_edit.release_focus()

func _on_LineEdit_focus_entered():
	Motion.ui_stop = true

func _on_LineEdit_focus_exited():
	Motion.ui_stop = false
