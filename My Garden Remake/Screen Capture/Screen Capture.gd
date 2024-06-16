extends Node2D

export var framerate = 20
export var seconds = 10
export var paused = false
export var playable = false

var captured = []
var frame = 0

func _ready():
	$Timer.start(1.0/framerate)

func _unhandled_input(event):
	if Input.is_action_just_pressed("capture"):
		var capture = get_tree().get_root().get_texture().get_data()
		capture.flip_y()
		
		Global.screenshots_taken += 1
		
		var dir = Directory.new()
		if !dir.dir_exists("user://Captures"):
			dir.make_dir("user://Captures")
		
		var time = OS.get_datetime()
		var fname = Global.selected_game + "-" + str(Global.day) + "-" + str(time.year) + "-" + str(time.month) + "-" + str(time.day) + "-" + str(time.hour) + "-" + str(time.minute) + "-" + str(time.second) + "-" + str(Global.screenshots_taken)
		capture.save_png("user://Captures/" + fname + ".png")
		
		Global.capture = capture
		Global.emit_signal("captured")
	
#	if Input.is_action_just_pressed("pause"):
#		paused = !paused
#		if playable:
#			$CanvasLayer/TextureRect.visible = paused
#			$CanvasLayer/TextureRect/ColorRect.visible = paused
#			frame = 0
#		print("Video paused: " + str(paused))

func _on_Timer_timeout():
	if paused && playable:
		var image_texture = ImageTexture.new()
		image_texture.create_from_image(captured[frame])
		
		$CanvasLayer/TextureRect.set_texture(image_texture)
		
		frame += 1
		if frame > captured.size() - 1:
			frame = 0
	if paused:
		return
	
	captured.append(get_tree().get_root().get_texture().get_data())
	
	if captured.size() > seconds * framerate:
		captured.remove(0)
