extends Node

signal time_over
signal rate_changed

const MAX_TIME = 60

var running = true

var actual_time_passed = 0.0
var time_passed = 0.0
var time_rate = 1.0
var percent_left = 1.0

var rate_change = ""

var rate_history = [Vector2(0,1)]

var factors = {}

func _process(delta):
	if !running:
		return
	
	time_passed += delta * time_rate
	actual_time_passed += delta
	percent_left = get_percent_left()
	
	if percent_left <= 0:
		stop()
		emit_signal("time_over")
		print("Time over")

func change_factor(fac,val):
	if factors.has(fac) && factors[fac] == val:
		return
	
	factors[fac] = val
	
	var sum = Tool.sum_dic(factors)
	var n_time_rate = (1.0) / (sum + 1)
	
	var n_rate_change = fac
	
	if n_rate_change.begins_with("[Audio"):
		n_rate_change = "Music"
	
	if n_rate_change == "boost":
		if factors["boost"] > 1:
			n_rate_change = "boost " + str(factors["boost"]) + "x"
	
	if time_rate > n_time_rate:
		n_rate_change = n_rate_change
	elif time_rate < n_time_rate:
		n_rate_change = ""
	else:
		n_rate_change = ""
	
	if n_rate_change.begins_with("_"):
		n_rate_change = ""
	
	rate_change = n_rate_change.capitalize()
	time_rate = n_time_rate
	
	if running:
		rate_history.append(Vector2(time_passed/MAX_TIME,time_rate))
	
	emit_signal("rate_changed")

func start():
	actual_time_passed = 0.0
	time_passed = 0.0
	rate_history = [Vector2(0,1)]
	factors = {}
	running = true

func stop():
	rate_history.append(Vector2(1,time_rate))
	running = false
	
	#Score Adjustment
	var over_time = time_passed - MAX_TIME
	actual_time_passed -= over_time * time_rate
	
	time_passed = 0.0

func get_percent_left():
	var p_left = 1 - (time_passed/MAX_TIME)
	
	if p_left < 0:
		p_left = 0
	
	return p_left
