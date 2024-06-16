extends Node2D

func _unhandled_input(_event):
	if Input.is_action_just_pressed("place"):
		place_trap()

func place_trap():
	if Global.current_trap != "":
			var mouse_position = get_global_mouse_position()
			
			if Global.invert_placement:
				mouse_position =  Global.player_pos - (mouse_position - Global.player_pos)
			
			var trap_name = Global.current_trap
			Global.current_trap = ""
			
			var trap_res = load("res://Objects/Traps/" + trap_name + "/" + trap_name + ".tscn")
			var new_trap = trap_res.instance()
			
			new_trap.position = mouse_position
			
			get_parent().call_deferred("add_child",new_trap)

func _on_Button_pressed():
	place_trap()
