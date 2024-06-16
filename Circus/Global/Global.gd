extends Node

signal inventory_changed(item)
signal abilities_changed(ability)
signal player_jumped

var inventory = []
var ability = []

enum SafePos {CIRCUS, PLATEAU_TOWN, PEAK_TRAIL, RUIN_HALL}
var safe_pos_list = {
	SafePos.CIRCUS: Vector2(),
	SafePos.PLATEAU_TOWN: Vector2(),
	SafePos.PEAK_TRAIL: Vector2(),
	SafePos.RUIN_HALL: Vector2()
} 
var player_safe_pos = SafePos.CIRCUS

#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func add_item(item):
	if !inventory.has(item):
		inventory.append(item)
		emit_signal("inventory_changed", item)

func has_item(item):
	return inventory.has(item)

func add_ability(a):
	if !ability.has(a):
		ability.append(a)
		emit_signal("abilities_changed", a)

func has_ability(a):
	return ability.has(a)
