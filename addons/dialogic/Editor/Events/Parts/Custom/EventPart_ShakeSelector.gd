tool
extends "res://addons/dialogic/Editor/Events/Parts/EventPart.gd"

onready var spinbox_duration := $SpinBox_Duration
onready var spinbox_intensity := $SpinBox_Intensity
onready var character_picker := $CharacterPicker

signal duration_changed(value)
signal amplitude_changed(value)
signal character_selected(data)


func _ready():
	spinbox_duration.connect('value_changed', self, '_on_SpinBox_Duration_value_changed')
	spinbox_intensity.connect('value_changed', self, '_on_SpinBox_Intensity_value_changed')
	character_picker.connect('data_changed', self, '_on_CharacterPicker_data_changed')


# called by the event block
func load_data(data:Dictionary):
	# First set the event_data
	.load_data(data)
	
	# Now update the ui nodes to display the data. 
	spinbox_duration.value = event_data['duration']
	spinbox_intensity.value = event_data['intensity']
	if event_data.has('character'):
		character_picker.load_data(
			{
				'character': event_data['character'],
				'event_id': 'dialogic_003', # Fake event_id for showing all character option
			})
		character_picker.visible = true
	else:
		character_picker.visible = false


# has to return the wanted preview, only useful for body parts
func get_preview():
	return ''


func set_duration(val: float):
	spinbox_duration.value = val


func set_intensity(val: float):
	spinbox_intensity.value = val


func set_character_data_by_file(file_name: String):
	character_picker.set_data_by_file(file_name)


func show_character_picker(show: bool):
	character_picker.visible = show


func _on_SpinBox_Duration_value_changed(value):
	event_data['duration'] = value
	
	# informs the parent about the changes!
	data_changed()


func _on_SpinBox_Intensity_value_changed(value):
	event_data['intensity'] = value
	
	# informs the parent about the changes!
	data_changed()


func _on_CharacterPicker_data_changed(data):
	event_data['character'] = data['character']
	
	# informs the parent about the changes!
	data_changed()
