## Cross-platform input manager
extends Node

## Gets the name of the button/input (ex: "E" on keyboards, or "Triangle" on DS controllers)
## Returns the value of _get_missing_key_name(action) if there is no action
func get_input_name(action: StringName) -> StringName:
	if not InputMap.has_action(action):
		push_error("InputManager.get_input_name: Action '%s' was not found" % action)
		return _get_missing_key_name(action)
	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey and not JoypadManager.controller_active:
			var key := event as InputEventKey
			return OS.get_keycode_string(key.get_physical_keycode_with_modifiers())
		elif event is InputEventJoypadButton:
			var button := event as InputEventJoypadButton
			return JoypadManager.get_name_for_input(button.button_index)
		elif event is InputEventJoypadMotion:
			## TODO: Properly handle controller motion here
			return event.as_text()
	return _get_missing_key_name(action)

## Like get_input_name, but if the name doesn't exist it looks through the other list members
func get_input_name_from_list(actions: Array[StringName]) -> StringName:
	for action in actions:
		var found: StringName = get_input_name(action)
		if found != _get_missing_key_name(action):
			return found
	return _get_missing_key_name(actions[0])

## The name for missing actions. 
func _get_missing_key_name(action: StringName) -> StringName:
	return "<%s>" % action
