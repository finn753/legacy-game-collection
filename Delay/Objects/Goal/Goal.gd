extends Area2D

export(AudioStream) var stream

onready var sprite = $Sprite
onready var label = $Label

var score = 0

func _ready():
	if scale.x < 0:
		label.rect_scale.x = -1
		label.align = Label.ALIGN_RIGHT
	
	$AudioStreamPlayer.stream = stream

func _process(delta):
	label.text = str(score)

func _on_Goal_body_entered(body):
	if body is RigidBody2D:
		score += 1
		body.teleport = body.start_pos
		$AudioStreamPlayer.play()
