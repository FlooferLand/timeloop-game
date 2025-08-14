extends CanvasLayer

@export var label: Label

var controller_active := false
var dialog_active := false

func _ready() -> void:
	controller_active = JoypadManager.controller_active
	_update_enabled()
	JoypadManager.active_state_changed.connect(func(active: bool) -> void:
		controller_active = active
		_update_enabled()
	)
	DialogManager.dialog_opened.connect(func() -> void:
		dialog_active = true
		_update_enabled()
	)
	DialogManager.dialog_closed.connect(func(closed_early: bool) -> void:
		dialog_active = false
		_update_enabled()
	)

func _update_enabled() -> void:
	visible = (controller_active and not dialog_active)
	if visible:
		label.text = ""
		var add_hint := func(t: String) -> void:
			label.text += "%s    " % t
		add_hint.call("Interact with %s\t" % InputManager.get_input_name("interact"))
		add_hint.call("Sprint with %s\t" % InputManager.get_input_name("sprint"))
