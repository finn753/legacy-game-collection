extends Line2D

onready var res = preload("res://Objects/Footprints/Footprint.tscn")

export var min_progress = 0
export var max_progress = -1

func _ready():
	if Global.progress >= min_progress && (Global.progress <= max_progress || max_progress < 0):
		for pn in points.size():
			var p = points[pn]
			var fp = res.instance()
			fp.position = p
			
			if pn < points.size() - 1:
				fp.rotation_degrees = rad2deg(Vector2(0,1).angle_to(p - points[pn+1]))
				add_child(fp)
