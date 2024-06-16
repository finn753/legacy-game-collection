extends Area2D

onready var indicator = $Indicator

var plant_res = load("res://Objects/Plant/Plant.tscn")

var parent

var overlapping = []
var colliding = false

var p_partner = []
var v_partner = []

func _ready():
	indicator.visible = false

func set_parent(p):
	parent = p
	
	parent.connect("on_watered",self,"overlapping_update")
	parent.connect("new_day",self,"new_day")

func new_day():
	overlapping_update()
	reproduce()

func reproduce():
	v_partner = []
	
	$Label.text = ""
	if p_partner.size() == 0:
		return
	
	if !is_viable():
		$Label.text = "nv"
		return
	
	for p in p_partner:
		if p.is_viable() || p.v_partner.size() != 0:
			if !v_partner.has(p):
				v_partner.append(p)
	
	var is_master = true
	
	for v in v_partner:
		if get_index() <= v.get_index():
			is_master = false
			break
	
	if is_master:
		var new_plant = plant_res.duplicate().instance()
		new_plant.position = parent.grid.grid_pos + position
		parent.get_parent().add_child(new_plant)
		var parents = v_partner
		parents.append(self)
		new_plant.initialize(parents)
		
#		print("I'm Master" + str(get_index()))
#		$Label.text = str(v_partner.size()) + str(get_index())

func overlapping_update():
	p_partner = []
	colliding = false
	
	for a in overlapping:
		if a.has_method("is_reproduction_area"):
			p_partner.append(a)
			continue
		
		if a.get_parent().get_parent().has_method("is_movable_object"):
			colliding = true
	
	$Label.text = str(p_partner.size())
	
	if is_viable():
		$Label.text = $Label.text + "v"

func is_viable():
	return !colliding && can_reproduce()

func can_reproduce():
	if parent == null:
		return false
	
	return parent.can_reproduce()

func _on_ReproductionArea_area_entered(a):
	if !overlapping.has(a):
		overlapping.append(a)
	
	overlapping_update()

func _on_ReproductionArea_area_exited(a):
	if overlapping.has(a):
		overlapping.remove(overlapping.find(a))
	
	overlapping_update()

func is_reproduction_area():
	return true

#func reproduce():
#	if !reproductable:
#		if viable:
#			$Label.text = "-"
#		return
#
#	if partners == []:
#		$Label.text = "0"
#		return
#
#	var is_master = true
#
#	for p in partners:
#		if get_index() <= p.get_index():
#			is_master = false
#			break
#
#	$Label.text = str(partners.size())
#
#	is_master = true
#
#	if is_master:
#		print("Im Master" + str(randi()))
#		var new_plant = plant_res.duplicate().instance()
#		new_plant.position = parent.grid.grid_pos + position
#		parent.get_parent().add_child(new_plant)
#		new_plant.initialize(partners)
#
#func update_area(checked = false):
#	partners = []
#	viable = can_reproduce()
#
#	if !viable:
#		reproductable = false
#		indicator.visible = reproductable
#		return
#
#	reproductable = false
#
#	if !checked:
#		for a in get_overlapping_areas():
#			if a.has_method("is_reproduction_area"):
#				a.update_area(true)
#				if a.viable:
#					reproductable = true
#					a.reproductable = true
#					partners.append(a)
#					if !a.partners.has(self):
#						a.partners = partners
#						a.partners.remove(a.partners.find(a))
#						a.partners.append(self)
#						a.get_node("Label").text = str(partners.size())
#				continue
#
#			if a.get_parent().get_parent().has_method("is_movable_object"):
#				reproductable = false
#				break
#	else:
#		reproductable = viable
#
#	indicator.visible = reproductable
#	$Label.text = str(partners.size())
