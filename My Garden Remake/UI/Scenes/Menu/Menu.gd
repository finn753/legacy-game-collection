extends CanvasLayer

onready var transition = $Transition
onready var select_button = $HBoxContainer/Select
onready var play_button = $HBoxContainer/Play
onready var select_screen = $"Select Screen"

var saved_games

func _ready():
	Global.connect("force_start",self,"start_game")
	Global.connect("deleted",self,"calculate_buttons")
	
	transition.open(1.0,0.25)
	$ParallaxBackground/ColorRect.visible = true
	
	calculate_buttons()

func calculate_buttons():
	saved_games = Global.get_saved_games()
	if saved_games.size() == 0:
		select_button.visible = false
		play_button.visible = false
#	elif saved_games.size() == 1:
#		select_button.visible = false
#		play_button.visible = true
	else:
		select_button.visible = true
		play_button.visible = true

func _on_Load_timeout():
	get_tree().change_scene("res://Garden/Garden.tscn")

func _on_Play_button_down():
	Global.load_settings()
	
	print(Global.last_played)
	
	if Global.last_played != null:
		Global.selected_game = Global.last_played
	else:
		var sgames = Global.get_saved_games()
		if Global.get_saved_games().size() == 0:
			play_button.visible = false
			return
		Global.selected_game = sgames[0]
	
	Global.new_garden = false
	start_game()

func _on_New_Game_button_down():
	Global.selected_game = Global.generate_garden_name()
	Global.new_garden = true
	start_game()

func start_game():
	transition.close(1.0)
	$Load.start(1.0)

func _on_Select_button_down():
	select_screen.toggle_visibility()
