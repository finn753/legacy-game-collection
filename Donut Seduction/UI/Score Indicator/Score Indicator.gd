extends Label

onready var animation = $AnimationPlayer
onready var sound = $SoundManager

export var highscore = false

func _ready():
	text = str(Global.score)

func _process(_delta):
	if !highscore:
		if Global.score_changed:
			Global.score_changed = false
			
			sound.play_sound("Score")
			animation.play("Jump Score")
			
		if Global.score == Global.highscore && Global.score != 0:
			text = "HI " + str(Global.score)
		else:
			text = str(Global.score)
	else:
		text = "HI " + str(Global.highscore)
