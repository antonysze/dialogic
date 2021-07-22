tool
extends "res://addons/dialogic/Nodes/dialog_node.gd"

const AUTO_ADVANCE_TIME = 1.0
const FADING_TIME = 0.5
onready var auto_advance_timer: Timer = $AutoAdvanceTimer
onready var original_pos: Vector2 = rect_position
var background_tween: Tween
var background: TextureRect
var shake_tween: Tween
var shake_intensity: float

var auto_advance_enabled := false


func load_theme(filename):
	var theme = .load_theme(filename)
	var buttons = $Buttons
	var margin_h = theme.get_value('text', 'margin_h', Vector2(20, 20))
	buttons.set('margin_left', margin_h.x)
	buttons.set('margin_right', -margin_h.y + 20)
	buttons.rect_position.y = $TextBubble.rect_position.y + buttons.rect_size.y * 1.5
	return theme


func _load_event():
	if auto_advance_enabled:
		auto_advance_timer.stop()
	._load_event()


func _other_event_handler(event: Dictionary):
	match event['event_id']:
		'dialogic_rr_001':
			_shake_screen_event(event)
		'dialogic_rr_002':
			_shake_character_event(event)


func _change_background_event(event: Dictionary):
	if event['background'] == '' and background != null:
		if event['fade']:
			_fade_out_background()
		else:
			background.queue_free()
			background = null
	else:
		if event['fade']:
			if background != null:
				_fade_out_background()
			_create_new_background()
			_setup_background(event)
			_fade_in_background()
		else:
			if background == null:
				_create_new_background()
			_setup_background(event)


func _fade_background(from, to):
	if background_tween == null:
		background_tween = Tween.new()
#warning-ignore:return_value_discarded
		background_tween.connect("tween_completed", self, '_on_Background_tween_completed')
		add_child(background_tween)
#warning-ignore:return_value_discarded
	background_tween.interpolate_property(background, "modulate:a", from, to, FADING_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#warning-ignore:return_value_discarded
	background_tween.start()


func _fade_in_background():
	_fade_background(0.0, 1.0)


func _fade_out_background():
	_fade_background(background.modulate.a, 0.0)
	background = null


func _on_Background_tween_completed(object, _key):
	if object != background:
		object.queue_free()


func _create_new_background():
	background = TextureRect.new()
	background.name = 'Background'
	background.expand = true
	background.anchor_left = 0.0
	background.anchor_right = 1.0
	background.anchor_top = 0.0
	background.anchor_bottom = 1.0
	background.show_behind_parent = true
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(background)


func _setup_background(event: Dictionary):
	background.texture = null
	if (background.get_child_count() > 0):
		for c in background.get_children():
			c.get_parent().remove_child(c)
			c.queue_free()
	if (event['background'].ends_with('.tscn')):
		var bg_scene = load(event['background'])
		if (bg_scene):
			bg_scene = bg_scene.instance()
			background.add_child(bg_scene)
	elif (event['background'] != ''):
		background.texture = load(event['background'])


func _shake_screen_event(event: Dictionary):
	if shake_tween == null:
		shake_tween = Tween.new()
		add_child(shake_tween)
	else:
#warning-ignore:return_value_discarded
		shake_tween.seek(INF)
	var duration = event['duration']
#warning-ignore:return_value_discarded
	shake_intensity = event['intensity'] * get_viewport_rect().size.y / 100.0
#warning-ignore:return_value_discarded
	shake_tween.interpolate_method(self, '_shake_dialogue_box', 0.0, 1.0, duration, Tween.TRANS_LINEAR)
#warning-ignore:return_value_discarded
	shake_tween.start()
	_load_next_event()


func _shake_character_event(event: Dictionary):
	var shake_all = event['character'] == '[All]'
	for p in $Portraits.get_children():
		if shake_all || p.character_data['file'] == event['character']:
			p.shake(event['intensity'], event['duration'])
	_load_next_event()


func _shake_dialogue_box(target):
	TweenUtils.shake_control(self, original_pos, target, shake_intensity)


# mouse click event
func _on_NextStringClickArea_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and _can_go_next():
		_next_action()


func _on_AutoAdvanceButton_toggled(button_pressed):
	auto_advance_enabled = button_pressed
	if button_pressed:
		if $TextBubble.is_finished() and waiting_for_answer == false and waiting_for_input == false:
			auto_advance_timer.start(AUTO_ADVANCE_TIME)
	else:

		auto_advance_timer.stop()


func _on_AutoAdvanceTimer_timeout():
	if _can_go_next() and $TextBubble.is_finished() and waiting_for_answer == false and waiting_for_input == false:
		_load_next_event()


func _on_text_completed():
	._on_text_completed()
	if auto_advance_enabled:
		auto_advance_timer.start(AUTO_ADVANCE_TIME)
