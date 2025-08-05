## Simplifies skipping through things, and prevents accidental skips
## set_action MUST be called
class_name SkipComponent extends Node

## Called when the action should be skipped
signal skipped

@export var bound_label: Label = null:
	get(): return bound_label
	set(value):
		bound_label = value
		_update_label()

@export_group("Local")
@export var skip_feedback: AudioStreamPlayer

const TIMES_TO_PRESS: int = 3

var times_pressed: int = 0
var _action_name: String = ""

func _ready() -> void:
	if OS.has_feature("web"):
		skip_feedback.playback_type = AudioServer.PLAYBACK_TYPE_SAMPLE
	JoypadManager.connect_state_changed(_update_label)
	_update_label()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip"):
		times_pressed += 1
		skip_feedback.play()
		skip_feedback.pitch_scale += 0.1
		skip_feedback.volume_db += 0.1
		_update_label()
		if times_pressed >= TIMES_TO_PRESS:
			skipped.emit()
			times_pressed = 0
		if _action_name.is_empty():
			push_error("No action name set on skip_component (%s)" % get_parent().name)

## The name of the thing the action will do (ex: "continue", "skip", "beat up the boss")
## This will be inserted as "Press X to {action}"
func set_action(action: String) -> void:
	_action_name = action
	_update_label()

## Gets the readable input name of the key needed to be pressed to skip
func get_input_name() -> StringName:
	return InputManager.get_input_name("skip")

func _update_label() -> void:
	if bound_label == null:
		return
	if _action_name.is_empty():
		bound_label.text = ""
		return
	var input_name: StringName = InputManager.get_input_name("skip")
	if times_pressed == 0:
		bound_label.text = "Press %s to %s" % [input_name, _action_name]
	else:
		var times_more: int = TIMES_TO_PRESS - times_pressed
		bound_label.text = "Press %s %s more times to %s" % [input_name, times_more, _action_name]
