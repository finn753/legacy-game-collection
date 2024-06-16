extends Timer

export var max_time = 10

export var fixed_time = false
export var time = 0

func _ready():
	Global.set_time(time)

func _on_AgeTimer_timeout():
	if fixed_time:
		return
	
	if Global.time >= max_time:
		return
	
	Global.set_time(Global.time + 1)
