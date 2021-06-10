tool
extends "res://addons/dialogic/Editor/Events/Templates/EventTemplate.gd"

const FADE_KEY := 'fade'
onready var fade_check_box : CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Header/FadeCheckBox

var preview_scene = preload("res://addons/dialogic/Editor/Events/Common/Images/ImagePreview.tscn")

var preview = "..."
var image_picker


func _ready():
	image_picker = get_header()
	# Needed to open the file dialog
	image_picker.editor_reference = editor_reference
	image_picker.connect("file_selected", self, "_on_file_selected")
	image_picker.connect("clear_pressed", self, "_on_clear_pressed")
	fade_check_box.connect("toggled", self, "_on_FadeCheckBox_toggled")
	# Init the data
	event_data = {
		'background': '',
		FADE_KEY: false
	}


func load_data(data):
	.load_data(data)
	load_image(event_data['background'])
	if not event_data.has(FADE_KEY):
		event_data[FADE_KEY] = false
	fade_check_box.pressed = event_data[FADE_KEY]


func load_image(img_src: String):
	event_data['background'] = img_src
	if not img_src.empty() and not img_src.ends_with('.tscn'):
		set_preview("...")
		set_body(preview_scene)
		get_body().set_image(load(img_src))
		image_picker.set_image(img_src)
	elif img_src.ends_with('.tscn'):
		set_preview("...")
		image_picker.set_image(img_src)
		set_body(null)
	else:
		set_body(null)
		image_picker.clear_image()


func _on_file_selected(path):
	load_image(path)


func _on_clear_pressed():
	load_image('')


func _on_FadeCheckBox_toggled(button_pressed: bool):
	event_data[FADE_KEY] = button_pressed
