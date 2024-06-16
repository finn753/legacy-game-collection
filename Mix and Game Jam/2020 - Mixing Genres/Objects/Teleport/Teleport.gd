extends Area2D

onready var voting = get_owner().get_node("Menu/Voting")

export var destination = ""

var player_count = 0


func _physics_process(delta):
	if player_count <= 0:
		return
	
	if player_count >= ceil(float(Global.player_data.size())/2):
		if get_tree().network_peer != null:
			rpc("teleport",destination)
		else:
			teleport(destination)

remotesync func teleport(m):
	Global.join_minigame(m)

func _on_Teleport_body_entered(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			player_count += 1
			Sound.play_sound("Vote")
		voting.text = destination + " (" + String(player_count) + "/" + String(ceil(float(Global.player_data.size())/2)) + ")"

func _on_Teleport_body_exited(body):
	if body.has_method("get_type"):
		if body.type == "Player":
			player_count -= 1
			Sound.play_sound("Unvote")
			
			if player_count <= 0:
				voting.text = ""
			else:
				voting.text = destination + " (" + String(player_count) + "/" + String(ceil(float(Global.player_data.size())/2)) + ")"
