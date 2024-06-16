extends Node

signal in_light_changed

var player

var entered_lights = []
var dashing = false

var in_light = false

var old_room = 10
var current_room = 11
var mansion_layout = {}

func _ready():
	VisualServer.set_default_clear_color(Color(0,0,0,1.0))

func add_in_light(n):
	if !entered_lights.has(n):
		entered_lights.append(n)
		update_in_light()

func remove_in_light(n):
	entered_lights.erase(n)
	update_in_light()

func toggle_dashing(b: bool):
	if b != dashing:
		dashing = b
		update_in_light()

func update_in_light():
	var n = false
	
	if dashing || !entered_lights.empty():
		n = true
	
	if n != in_light:
		in_light = n
		emit_signal("in_light_changed")
