## Like a BoxContainer, but with controller support for buttons.
## Also improves accesibility
extends BoxContainer

@onready var buttons: Array[Button]
var controller_connected: bool = false
var controller_awaiting_update: bool = false

func _enter_tree() -> void:
	# Setting up button stuff at the start
	for i in range(get_child_count()):
		var child := get_child(i)
		if child is Button:
			var button: Button = child as Button
			buttons.push_back(button)
	if JoypadManager.connected:
		controller_connected = true
		controller_awaiting_update = true
	_update_buttons()
	
	# Waiting for controller state change
	JoypadManager.connection_state_changed.connect(func(connected: bool) -> void:
		controller_connected = connected
		controller_awaiting_update = true
		_update_buttons()
	)

func _update_buttons() -> void:
	await get_tree().process_frame
	for i in range(buttons.size()):
		var button: Button = buttons[i]
		button.focus_mode = Control.FOCUS_ALL if controller_connected else Control.FOCUS_NONE
		button.focus_behavior_recursive = FOCUS_BEHAVIOR_ENABLED if controller_connected else FOCUS_BEHAVIOR_DISABLED
		if controller_awaiting_update and controller_connected and i == 0:
			button.grab_focus()
	controller_awaiting_update = false
