extends HSlider

export var bus = ""

onready var bus_idx = AudioServer.get_bus_index(bus)
onready var bus_volume = AudioServer.get_bus_volume_db(bus_idx)

func _ready():
	value = db2linear(bus_volume)

func _on_VolumeSlider_value_changed(v):
	bus_volume = linear2db(v)
	AudioServer.set_bus_volume_db(bus_idx,bus_volume)

func _on_VolumeSlider_focus_exited():
	Save.save_settings()
