extends Timer

export var enemys = "Dog"
export var wait_start = 2
export var intervall = 15

var enemy_res = preload("res://Enemy/Enemy.tscn")

func _ready():
	wait_time = wait_start
	start()

func spawn_enemy():
	randomize()
	var pos_list = get_children()
	var spawn_point = pos_list[randi()%pos_list.size()].position
	
	randomize()
	var enemy_list = enemys.split(",")
	var spawn_enemy = enemy_list[randi()%enemy_list.size()]
	
	var new_enemy = enemy_res.instance()
	new_enemy.position = spawn_point
	new_enemy.skin = spawn_enemy
	
	get_parent().call_deferred("add_child",new_enemy)

func _on_Enemy_Spawn_System_timeout():
	wait_time = intervall
	spawn_enemy()
