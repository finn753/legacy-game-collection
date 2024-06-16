extends Sprite

const TYPE = "Plant"

export var type = "Hanging"
export var color = "White"

onready var sex = $"Sex Area"
onready var water_indicator = $Water

var path = "res://Plant/"

var update_day = false

export var age = 1
var reproduce = 0
var watered = 0

var colors = ["Black","Grey","White","Pink","Red","Orange","Yellow","Violet","Blue"]
var types = ["Hanging","BigHead"]

func _ready():
	var err = Global.connect("new_day",self,"new_day")
	if err == 0:
		err = 0
	randomize()
	
	if watered <= 0:
		water_indicator.animation = "unwatered"
	else:
		water_indicator.animation = "watered"
	
	reload()

func _process(_delta):
	if update_day == null:
		update_day = true
	elif update_day:
		update_day = false
		next_day()

func new_day():
	update_day = null

func next_day():
	if randi()%3 < 3 && watered > 0:
		age += 1
	
	if reproduce > 0:
		reproduce -= 1
	
	reload()
	do_reproduce()
	
	if watered > 0:
		watered -= 1
	
	if watered <= 0:
		water_indicator.animation = "unwatered"
	else:
		water_indicator.animation = "watered"

func mutate(partner_a,partner_b):
	randomize()
	var r = randi()%3
	
	if r == 1:
		color = partner_a.color
	elif r == 2:
		color = partner_b.color
	else:
		color = colors[randi()%colors.size()]
	
	randomize()
	r = randi()%3
	
	if r == 1:
		type = partner_a.type
	elif r == 2:
		type = partner_b.type
	else:
		type = types[randi()%types.size()]

func water():
	if watered <= 0:
		Audio.play_sound("Watered")
		watered = 1
	water_indicator.animation = "watered"

func reload():
	if age <= 10:
		set_texture(load(path + type + "/" + color + "/" + color + str(age) + ".png"))
	else:
		set_texture(load(path + type + "/" + color + "/" + color + "10.png"))

func do_reproduce():
	if reproduce > 0 || watered <= 0 || age < 10:
		return
	for a in sex.get_overlapping_areas():
		if a.get_parent().has_method("get_type"):
			if a.get_parent().get_type() == "Plant":
				var body = a.get_parent()

				if position >= body.position || body.reproduce > 0 || body.age <= 10|| body.watered <= 0 || randi()%3 < 1:
					continue

				var child_pos = (position + body.position) / Vector2(2,2)

				var new_plant = self.duplicate()
				new_plant.age = 1
				new_plant.position = child_pos
				new_plant.mutate(self,body)
				
				get_parent().call_deferred("add_child",new_plant)
				print("Planted")
				reproduce = 3
				break

func grab():
	pass

func ungrab():
	pass

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"type" : type,
		"color" : color,
		"age" : age,
		"reproduce" : reproduce,
		"watered" : watered,
	}
	return save_dict

func get_type():
	return TYPE
