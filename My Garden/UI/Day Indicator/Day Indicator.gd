extends Label

onready var animation = $AnimationPlayer

func _ready():
	var err = Global.connect("new_day",self,"new_day")
	if err == 0:
		err = 0
	text = "Day "

func _process(_delta):
	text = "Day " + str(Global.day)

func new_day():
	animation.play("NewDay")
