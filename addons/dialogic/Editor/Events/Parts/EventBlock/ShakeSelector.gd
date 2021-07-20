tool
extends HBoxContainer

onready var spinbox_duration := $SpinBox_Duration
onready var spinbox_amplitude := $SpinBox_Amplitude
onready var character_picker := $CharacterPicker

signal duration_changed(value)
signal amplitude_changed(value)
signal character_selected(data)


func _ready():
	character_picker.default_option_name = '[All]'
	character_picker.default_option_metadata = {
		'file': '[All]'
	}


func set_duration(val: float):
	spinbox_duration.value = val


func set_amplitude(val: float):
	spinbox_amplitude.value = val


func set_character_data_by_file(file_name: String):
	character_picker.set_data_by_file(file_name)


func show_character_picker(show: bool):
	character_picker.visible = show


func _on_SpinBox_Duration_value_changed(value):
	emit_signal("duration_changed", value)


func _on_SpinBox_Amplitude_value_changed(value):
	emit_signal("amplitude_changed", value)


func _on_CharacterPicker_character_selected(data):
	emit_signal("character_selected", data)
