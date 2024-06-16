extends CanvasLayer

onready var animation = $AnimationPlayer

onready var master_volume = $"Volume Control/Master Volume"
onready var music_volume = $"Volume Control/Music Volume"
onready var sound_volume = $"Volume Control/Sound Volume"

var visible = false

func _ready():
	master_volume.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_volume.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sound_volume.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")))

func pause():
	visible = true
	animation.play("Show")

func unpause():
	visible = false
	animation.play("Hide")
	Global.save_game()

func _on_Exit_button_down():
	if visible:
		unpause()
	elif !visible:
		pause()

func _on_Master_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),round(linear2db(value)))

func _on_Sound_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),round(linear2db(value)))

func _on_Music_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),round(linear2db(value)))
