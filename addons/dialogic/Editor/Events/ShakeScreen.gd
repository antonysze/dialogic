tool
extends "res://addons/dialogic/Editor/Events/Templates/EventTemplate.gd"


func _ready():
	_set_default_data()
	_setup_data()
	_setup_signal()


func _set_default_data():
	event_data = {
		'shake_amplitude': 1.0,
		'duration': 0.25,
	}
	get_header().show_character_picker(false)


func _setup_data():
	var header = get_header()
	header.set_duration(float(event_data['duration']))
	header.set_amplitude(float(event_data['shake_amplitude']))
	

func _setup_signal():
	var header = get_header()
	header.connect("duration_changed", self, "_on_Selector_duration_changed")
	header.connect("amplitude_changed", self, "_on_Selector_amplitude_changed")


func load_data(data):
	.load_data(data)
	_setup_data()


func _on_Selector_duration_changed(value):
	event_data['duration'] = value


func _on_Selector_amplitude_changed(value):
	event_data['shake_amplitude'] = value
