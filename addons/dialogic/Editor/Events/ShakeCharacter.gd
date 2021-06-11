tool
extends "res://addons/dialogic/Editor/Events/ShakeScreen.gd"


func _set_default_data():
	event_data = {
		'shake_amplitude': 1.0,
		'duration': 0.25,
		'character': '',
	}
	get_header().show_character_picker(true)


func _setup_data():
	._setup_data()
	get_header().set_character_data_by_file(event_data['character'])
	

func _setup_signal():
	._setup_signal()
	get_header().connect("character_selected", self, "_on_Selector_character_changed")
	

func _on_Selector_character_changed(value):
	event_data['character'] = value['file']
