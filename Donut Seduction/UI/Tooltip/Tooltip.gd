extends Label

export(String,"Custom","Placement") var mode = ""

onready var anim = $AnimationPlayer

var cache1 = ""

func _ready():
	if mode == "Custom":
		set_process(false)
	
	visible = false

func _process(delta):
	if mode == "Placement":
		if cache1 != Global.current_trap:
			cache1 = Global.current_trap
			
			if Global.current_trap != "":
				rect_pivot_offset = rect_size / 2
				anim.play("Show")
			else:
				anim.play("Hide")
