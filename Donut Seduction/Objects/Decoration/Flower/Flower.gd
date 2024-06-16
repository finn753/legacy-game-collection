extends AnimatedSprite

onready var timer = $Timer

var colors = ["White","Blue","Pink","Purple","Red"]
var color = 0

func _ready():
	randomize()
	color = randi()%colors.size()
	animation = colors[color]

func _on_Area2D_body_entered(body):
	if animation != "-" && body.has_method("heal"):
		Audio.play_sound("Break")
	
	animation = "-"
	timer.start()

func _on_Timer_timeout():
	animation = colors[color]
