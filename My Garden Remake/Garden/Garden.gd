extends Node2D

onready var tilemap = $TileMap
onready var transition = $Overlay/Transition

func _ready():
	$ParallaxBackground/ColorRect.visible = true
	
	Global.tilemap_node = tilemap
	Global.color_stats = {
		0: 0,
		1: 0,
		2: 0,
		3: 0,
		4: 0,
		5: 0
	}
	
	Global.species_stats = {
		0: 0,
		1: 0,
		2: 0
	}
	
	if Global.new_garden || Global.selected_game == "debug":
		randomize()
		Global.starter_flower_c = randi()%6
	
	load_game()
	transition.open(2.0,0.25)
	
	Global.last_played = Global.selected_game
	Global.save_settings()
	
	if Global.new_garden:
		Global.day = 1
	
	#Global.save_game()

func load_game():
	var save_data = Global.load_game()
	
	if save_data == null || Global.selected_game == "debug":
		Global.emit_signal("clean_outside_area")
		return
	
	#REVERT GAME STATE
	var old_plants = get_tree().get_nodes_in_group("Plant")
	for op in old_plants:
		op.queue_free()
	
	var old_deco = get_tree().get_nodes_in_group("Decoration")
	for od in old_deco:
		od.queue_free()
	
	for p in save_data["plants"]:
		var nplant = load("res://Objects/Plant/Plant.tscn").instance()
		get_node(p["parent"]).add_child(nplant)
		nplant.load_state(p)
	
	for d in save_data["decoration"]:
		var ndeco = load(d["res_path"]).instance()
		get_node(d["parent"]).add_child(ndeco)
		ndeco.load_state(d)
	
	for t in save_data["tilemap"]:
		tilemap.set_cellv(t,1)
	
	tilemap.update_bitmask_region()
	#Global.emit_signal("clean_outside_area")
