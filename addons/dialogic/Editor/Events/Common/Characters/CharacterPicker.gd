tool
extends HBoxContainer

signal character_selected(data)

const DEFULTA_COLOR := Color('#FFFFFF')
var default_option_name := '[Character]'
var default_option_metadata := {}

func _ready():
	$Dropdown.get_popup().connect("index_pressed", self, '_on_character_selected')


func _on_Dropdown_about_to_show():
	var popup = $Dropdown.get_popup()
	popup.clear()
	popup.add_item(default_option_name)
	popup.set_item_metadata(0, default_option_metadata)
	
	var index = 1
	for c in DialogicUtil.get_sorted_character_list():
		popup.add_item(c['name'])
		popup.set_item_metadata(index, c)
		index += 1


func _on_character_selected(index: int):
	var metadata = $Dropdown.get_popup().get_item_metadata(index)
	if index == 0:
		set_data(default_option_name, DEFULTA_COLOR)
	else:
		set_data($Dropdown.get_popup().get_item_text(index), metadata['color'])
	emit_signal('character_selected', metadata)
	return metadata


func set_data_by_file(file_name: String):
	if file_name != '' && file_name != default_option_name:
		# This method is used when you don't know the character's color
		var character = DialogicResources.get_character_json(file_name)
		set_data(character['name'], Color(character['color']))
	else:
		set_data(default_option_name, DEFULTA_COLOR)


func set_data(text: String, color: Color = DEFULTA_COLOR):
	if not text.empty():
		$Dropdown.text = text
	else:
		$Dropdown.text = default_option_name
	$Icon.set("self_modulate", Color(color))
