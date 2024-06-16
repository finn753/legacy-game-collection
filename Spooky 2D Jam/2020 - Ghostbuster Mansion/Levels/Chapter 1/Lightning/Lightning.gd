extends Node2D

onready var window1 = $"Windows/Window"
onready var window2 = $"Windows/Window4"
onready var timer = $Timer

const TIMER = 1

func _ready():
	window1.window = false
	window2.window = false
	timer.wait_time = TIMER

func _on_Timer_timeout():
	window1.window = !window1.window
	window2.window = window1.window
	
	if window1.window:
		timer.wait_time = TIMER
	else:
		timer.wait_time = 0.5
